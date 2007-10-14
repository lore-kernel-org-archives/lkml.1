Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbXJNPh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbXJNPh2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 11:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbXJNPhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 11:37:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36430 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbXJNPhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 11:37:15 -0400
Date: Sun, 14 Oct 2007 08:36:44 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove GPL restriction from set_dumpable()
Message-ID: <20071014083644.2846f6b8@laptopd505.fenrus.org>
In-Reply-To: <Pine.LNX.4.64.0710141257030.20620@jikos.suse.cz>
References: <Pine.LNX.4.64.0710141257030.20620@jikos.suse.cz>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Oct 2007 13:04:31 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> From: Jiri Kosina <jkosina@suse.cz>
> 
> remove GPL restriction from set_dumpable()
> 
> Commit 6c5d5238 introduced a set_dumpable() function that replaced
> the direct access to mm_struct->dumpable. I don't think there is any
> reason to restrict this function to EXPORT_SYMBOL_GPL() -- previously
> any module could modify current->mm->dumpable without any
> resitrictions, so it makes a little sense to turn this into 'internal
> interface' at once.
> 

but modules really have no business setting process's dumpable flags...
other than very internal modules.
