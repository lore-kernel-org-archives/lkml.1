Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbYDLV1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbYDLV1i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 17:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYDLV11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 17:27:27 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39944 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750910AbYDLV11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 17:27:27 -0400
Date: Sat, 12 Apr 2008 22:23:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: remove ->write_proc hooks
Message-ID: <20080412222334.280b3fb8@core>
In-Reply-To: <20080412210452.GD9151@martell.zuzino.mipt.ru>
References: <20080412210452.GD9151@martell.zuzino.mipt.ru>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 01:04:52 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> tty drivers are using ->read_proc hook, but not ->write_proc.
> Remove the latter, before anyone notices.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Andrew - please don't apply this for the moment as tty_set_operations and
per driver operations copies are going away. I'll merge an equivalent
tty->ops based patch into my tree.

Alan
