Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbYA0Ne5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbYA0Ne5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 08:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYA0Neu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 08:34:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:8249 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYA0Net (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 08:34:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:content-type:content-transfer-encoding:mime-version:subject:date:x-mailer;
        b=BU+MP330STlPgFdTcK46F4b9PQX7umUsK+o7W10VOz/EnQr38FjqEJnsprBxWybxOt5OfsRZRdqYgqXghX1pNG/k3fFzfDTmyMZJoGuobhyO1th2ugUq6T0Uv8RmChXg6DolDL5i00rxIcN2GCK89MnQTDEKslrqVCbfGyp/cCU=
Message-Id: <65607513-6FAC-4E9C-AB31-E86ECFF98EC2@gmail.com>
From: Rachel Greenham <rachel.greenham@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: netatalk slow after system upgrade (possibly kernel problem?)
Date: Sun, 27 Jan 2008 13:34:44 +0000
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(this thread came up in searching about the problem myself, so joined  
to post this, hence the 'broken' threading, I expect:)

Andrew Morton asked:

> It would be interesting if this could be repeated on bare hardware,  
> so we
> can eliminate the possibility that it is some weird interaction with  
> vmware.

I can confirm this; I'm seeing exactly these symptoms where the linux  
box running netatalk is running natively, not in VMWare. VMWare server  
is *installed* but only running in the sense that the vmnet interfaces  
are active.

Which begs an obvious test... There's no change when I kill the vmware  
networking (and all other) services. It still reckons it's going to  
take 24 minutes to transfer a file a little under a gigabyte.

Although, in fact, this thread does present a likely temporary  
workaround; to install a linux with an older kernel into vmware and  
use that to serve my content. :-D

That Linux system is Ubuntu Gutsy all up to date on amd64.

rachel@mab:~$ uname -a
Linux mab.local 2.6.22-14-generic #1 SMP Tue Dec 18 05:28:27 UTC 2007  
x86_64 GNU/Linux

netatalk 2.0.3-6ubuntu1 (built with ssl)

I'm getting between 500KB/s and 1MB/s on copies from that machine to a  
couple of macs on the local (gigabit) LAN. (They're both Intel macs  
running Leopard all up to date.)

Conversely I'm getting between 20MB/s and 40MB/s on copies from the  
macs to the netatalk server. (The variance is between the macs; one of  
them seems to be copying about twice as fast as the other probably due  
to issues of their own, but both clearly show that reading from  
netatalk is heavily crippled.

NB: I also posted this as a bug on ubuntu launchpad here:

https://bugs.launchpad.net/ubuntu/+source/netatalk/+bug/186327

But I noticed your precise question and thought I'd answer it. Don't  
know how useful I can be in here but I can certainly respond to  
requests for further info.

-- 
Rachel

