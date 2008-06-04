Return-Path: <linux-kernel-owner+w=401wt.eu-S1759467AbYFDPRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbYFDPRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYFDPRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:17:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbYFDPRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:17:14 -0400
Date: Wed, 4 Jun 2008 11:16:49 -0400
From: Alan Cox <alan@redhat.com>
To: Joe Peterson <joe@skyrush.com>
Cc: Alan Cox <alan@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <davidn@davidnewall.com>, Willy Tarreau <w@1wt.eu>,
       Harald Dunkel <harald.dunkel@t-online.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
Message-ID: <20080604151649.GB12625@devserv.devel.redhat.com>
References: <48434D57.6030801@skyrush.com> <48438126.3080308@t-online.de> <20080602053256.GF5609@1wt.eu> <20080602091016.571dda7c@core> <4843B6EE.8080104@davidnewall.com> <20080602102033.63e4cd18@core> <48441138.90503@skyrush.com> <20080602155133.GC933@devserv.devel.redhat.com> <4846A9F4.40003@skyrush.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4846A9F4.40003@skyrush.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 08:43:00AM -0600, Joe Peterson wrote:
> 
> So the error that gets returned to set_termios() is -512.
> 
> Also, the various checks before this point (of course) did not pass
> (current->signal->tty != tty, !tty->pgrp, task_pgrp(current) ==
> tty->pgrp, is_ignored(SIGTTOU), is_current_pgrp_orphaned()).  I have not
> printed out the various values from these - let me know if this would be
> helpful.  I wanted to pass this info along now in case it is of help.

See what tty->pgrp is at that point when it hangs and that might identify
who is owning the tty and tty setup
