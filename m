Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbXJASKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbXJASKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbXJASKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:10:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55433 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbXJASKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:10:03 -0400
Date: Mon, 1 Oct 2007 11:08:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] Uninline fork.c/exit.c
Message-ID: <20071001110814.4e137e03@laptopd505.fenrus.org>
In-Reply-To: <20071001121553.GA6153@localhost.sw.ru>
References: <20071001121553.GA6153@localhost.sw.ru>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007 16:15:53 +0400
Alexey Dobriyan <adobriyan@sw.ru> wrote:

> Save ~650 bytes here.
> 
> add/remove: 4/0 grow/shrink: 0/7 up/down: 430/-1088 (-658)
> function                                     old     new   delta
> __copy_fs_struct                               -     202    +202
> __put_fs_struct                                -     112    +112
> __exit_fs                                      -      58     +58
> __exit_files                                   -      58     +58
> exit_files                                    58       2     -56
> put_fs_struct                                112       5    -107
> exit_fs                                      161       2    -159
> sys_unshare                                  774     590    -184
> copy_process                                4031    3840    -191
> do_exit                                     1791    1597    -194
> copy_fs_struct                               202       5    -197
> 
> No difference in lmbench lat_proc tests on 2-way Opteron 246.
> Smaaaal degradation on UP P4 (within errors).
> 

is there any impact on stack usage?
