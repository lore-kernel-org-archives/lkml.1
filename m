Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbZEQRQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbZEQRQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 13:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbZEQRQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 13:16:45 -0400
Received: from neskaya.eckenfels.net ([195.49.138.57]:54109 "EHLO
	neskaya.eckenfels.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZEQRQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 13:16:44 -0400
X-Greylist: delayed 2870 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 May 2009 13:16:44 EDT
Date: Sun, 17 May 2009 18:27:27 +0200 (CEST)
Message-Id: <200905171627.n4HGRRGO075133@neskaya.eckenfels.net>
From: Bernd Eckenfels <bernd-09@eckenfels.net>
To: linux-kernel@vger.kernel.org
Subject: Re: dd if=/dev/random of=data.bin bs=512 count=1
In-Reply-To: <19ac3f7a0905170822q28255239nea01b56d52e3ddf8@mail.gmail.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.8.3-20070201 ("Scotasay") (UNIX) (FreeBSD/7.2-PRERELEASE (i386))
X-Spam-Score: -0.8 (/)
X-Spam-Report: Spam detection software, running on the system "neskaya.eckenfels.net", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	The administrator of that system for details.
	Content preview:  In article <19ac3f7a0905170822q28255239nea01b56d52e3ddf8@mail.gmail.com>
	you wrote: > Issuing this command, I expected to get a file 4096 bytes in
	size. one time 512 is 512 not 4096. > if I have a count=10 it hangs forever
	(several hours). [...] 
	Content analysis details:   (-0.8 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.4 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	0.3 LONGWORD               BODY: Uses overlong words
	0.4 AWL                    AWL: From: address is in the auto white-list
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: ecki@neskaya.eckenfels.net
X-SA-Exim-Scanned: No (on neskaya.eckenfels.net); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <19ac3f7a0905170822q28255239nea01b56d52e3ddf8@mail.gmail.com> you wrote:
> Issuing this command, I expected to get a file 4096 bytes in size.

one time 512 is 512 not 4096.

> if I have a count=10 it hangs forever (several hours).

It depends on your harware and usage type (mouse atached?) how much entropy
is generated and filled into the pool.  If you drain it, it will hang for
/dev/random and generate PRNG data with /dev/urandom. 

You should think carefully about sucking too many random bytes from /dev/random.

> $ dd if=/dev/random of=data.bin bs=512 count=1
> 0+1 records in
> 0+1 records out
> 8 bytes (8 B) copied, 4.47366 s, 0.0 kB/s

I am not sure why you only get 8bytes here, but I would suggest to use "bs=1
count=256" anyway.

Gruss
Bernd
