Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbXHESom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbXHESom (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 14:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXHESof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 14:44:35 -0400
Received: from mail.gmx.net ([213.165.64.20]:35525 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751918AbXHESoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 14:44:34 -0400
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX1+WnR4wr6+WWVx1GdmVqtaqUAocFPd6jJqXxa/EZx
	qOmal28Cn6gsnJ
From: Dimitrios Apostolou <jimis@gmx.net>
To: =?utf-8?q?Rafa=C5=82_Bilski?= <rafalbilski@interia.pl>
Subject: Re: high system cpu load during intense disk i/o
Date: Sun, 5 Aug 2007 21:42:13 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200708031903.10063.jimis@gmx.net> <200708051903.12414.jimis@gmx.net> <46B60FB7.8030301@interia.pl>
In-Reply-To: <46B60FB7.8030301@interia.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708052142.14630.jimis@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 August 2007 20:58:15 Rafał Bilski wrote:
> > Hello again,
>
> Hi!
>
> > was my report so complicated? Perhaps I shouldn't have included so many
> > oprofile outputs. Anyway, if anyone wants to have a look, the most
> > important is two_discs_bad.txt oprofile output, attached on my original
> > message. The problem is 100% reproducible for me so I would appreciate if
> > anyone told me he has similar experiences.
>
> Probably nobody replied to Your message because people at this list think
> that Your problem isn't kernel related. In this moment I'm using "Arch
> Linux" too, so I checked /etc/cron directory. There simple jobs You are
> talking about are not so simple:
> - update the "locate" database,
> - update the "whatis" database.
> Both jobs are scaning "/" partition. I don't know how dcron works, but I
> can imagine situation in which it is polling cron.daily and says: "hey it
> wasn't done today yet" and it is starting same jobs over and over again.
> More and more tasks scans the "/" partition and in result access is slower
> and slower.

Hello and thanks for your reply. 

The cron job that is running every 10 min on my system is mpop (a 
fetchmail-like program) and another running every 5 min is mrtg. Both 
normally finish within 1-2 seconds. 

The fact that these simple cron jobs don't finish ever is certainly because of 
the high system CPU load. If you see the two_discs_bad.txt which I attached 
on my original message, you'll see that *vmlinux*, and specifically the 
*scheduler*, take up most time. 

And the fact that this happens only when running two i/o processes but when 
running only one everything is absolutely snappy (not at all slow, see 
one_disc.txt), makes me sure that this is a kernel bug. I'd be happy to help 
but I need some guidance to pinpoint the problem. 


Thanks, 
Dimitris
