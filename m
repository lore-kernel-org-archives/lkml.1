Return-Path: <linux-kernel-owner+w=401wt.eu-S1764158AbXG2QoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764158AbXG2QoM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 12:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763748AbXG2Qn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 12:43:56 -0400
Received: from web52007.mail.re2.yahoo.com ([206.190.48.56]:30057 "HELO
	web52007.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761486AbXG2Qnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 12:43:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Tf9/u91LLA6E/Ay7pCwVd47T6Zm8lLzw4HpJBJ67g/Bv7jc3ROukVt/4n79L/JrJ3bBYofKWi5Dj0w3Pi/qU0lKlzc/RvAhm64Qv//7tFpiRs183CvHoBIckEeG5wvNkRjC8Zd87nyeEckoTO7XteXySUauC7ObEBCisdQQVRys=;
X-YMail-OSG: OQf70t4VM1mKTKGRcywwLO146CbmX2wIQjCsLA6MOoW9Y5yQoFSeCN71bRXkUHJxaU.QdVruCVddzy5LA46hrtQCw8rFl.oBOdi7mPRsUotJBYImlEpquUzNb6i1DtbPAHo7Hvw8hS21YEjbUxmY2s8k5w--
Date: Sun, 29 Jul 2007 09:43:54 -0700 (PDT)
From: "Hendrik ." <chasake@yahoo.com>
Subject: Re: Reading a bad sector does not report failure as 'read error' but hangs PC with 'Machine Check Exception'
To: linux-kernel@vger.kernel.org
In-Reply-To: <46ACB357.4030006@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <626611.9154.qm@web52007.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > HARDWARE ERROR
> > CPU 0: Machine Check Exception: 4  Bank 4:
> > b200000000070f0f
> > TSC b7d4a144d0
> > This is not a software problem!
> > Run through mcelog --ascii to decode and contact
> your
> > hardware vendor
> > Kernel panic - not syncing: Machine check
> 
> You should run this through mcelog as it suggests
> and see what it shows. 
>   The kernel should be handling this properly,
> unless the drive problem 
> is causing the controller to do something bad. Note
> that kernels 2.6.20 
> and later use ADMA mode on the nForce4 SATA
> controller whereas previous 
> versions used it essentially like a PATA controller,
> so it is not 
> surprising that the behavior is different.

How can I do this? I have installed mcelog but I
cannot run it after the MCE error because the whole PC
hangs. If I try it after a reboot with 'mcelog --k8
--ascii' or whatever parameter, there is no output at
all. If I try to redirect the output to the syslog,
nothing is in there because the computer stopped
working and did not save the log anymore.

Isn't it strange to say that the controller does
something bad if there is just a bad sector on the
drive that is reported and handled correctly in an
older kernel (I have confirmed a bad sector on the
drive using the Seatools software from Seagate)? In my
opinion a kernel should not stop responding at all
with a bad sector on the disk. I cannot change the
controller's behavior and did all the updates there
are to make in function, but the problem is introduced
using the newer kernel series.

Perhaps nobody has tried accessing a bad SATA drive
before, to simulate such an error? If it helps I could
try a different type of motherboard to see what
happens there? (Asus M2NPV-VM)

Regards,
Hendrik


       
____________________________________________________________________________________
Moody friends. Drama queens. Your life? Nope! - their life, your story. Play Sims Stories at Yahoo! Games.
http://sims.yahoo.com/  
