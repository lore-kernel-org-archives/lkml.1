Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYCPXLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYCPXLu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYCPXLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:11:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49460 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752663AbYCPXLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:11:42 -0400
Date: Sun, 16 Mar 2008 22:55:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] don't panic if /sbin/init exits or killed
Message-ID: <20080316225534.5f7dc339@core>
In-Reply-To: <20080316230346.GA379@tv-sign.ru>
References: <20080316155453.GA20845@tv-sign.ru>
	<20080316221938.D217026F995@magilla.localdomain>
	<20080316230346.GA379@tv-sign.ru>
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

> Well, I think the generic "if we have a chance to survive, we should try
> to survive" rule is good.
> 
> If the boot init dies, at least the admin has a chance to figure out what
> has happened, and -o remount,ro /.

A long long time ago someone posted a patch which arranged that if the
init process died it got respawned via the same list of process names as
happens on boot.

Or for that matter we could catch the dying init and replace it with a
kernel side while(1) wait(NULL); so that we at least continue the cleanup.

Alan
