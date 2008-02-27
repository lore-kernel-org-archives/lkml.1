Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbYB0UMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbYB0UMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbYB0UMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:12:35 -0500
Received: from oswiecenia.net ([83.13.108.58]:3797 "EHLO poczta.oswiecenia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757339AbYB0UMe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:12:34 -0500
X-Greylist: delayed 758 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2008 15:12:34 EST
From: Tomasz Grobelny <tomasz@grobelny.oswiecenia.net>
To: Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] x86 tls prevent_tail_call
Date: Wed, 27 Feb 2008 20:59:40 +0100
User-Agent: PLD Linux KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20080226210018.A031B26F9A4@magilla.localdomain> <20080227072617.GB4638@elte.hu> <20080227073821.0C34C2700FD@magilla.localdomain>
In-Reply-To: <20080227073821.0C34C2700FD@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802272059.40567.tomasz@grobelny.oswiecenia.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia Wednesday 27 of February 2008, Roland McGrath napisa³:
> > i'm wondering, have you seen this happen in practice? We use
> > sys_set_thread_area() for every new task started up. I guess we havent
> > seen problems in the field yet because this early during startup tasks
> > do not normally receive signals? (or if they do they are fatal and no
> > user signal context is used.)
>
> Tomasz saw it.  I don't know what compiler or exact options to it he used.
>
VMware image from http://student.agh.edu.pl/~grobelny/linux/BUG.tar 
demonstrates the problem. I didn't play with compiler options myself but used
http://cvs.pld-linux.org/cgi-bin/cvsweb.cgi/SPECS/kernel-vanilla.spec (rev. 
1.129) as basis for my build.
-- 
Regards,
Tomasz Grobelny
