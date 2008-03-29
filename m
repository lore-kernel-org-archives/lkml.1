Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbYC2VB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbYC2VB6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 17:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYC2VBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 17:01:51 -0400
Received: from n26.bullet.mail.mud.yahoo.com ([68.142.206.221]:38282 "HELO
	n26.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754607AbYC2VBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 17:01:50 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Mar 2008 17:01:50 EDT
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 395390.14568.bm@omp109.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=3vm/e0LRVvkwXYhKepDQ+TjL4tllE6a3frHMh0hTmSuZlqDKOG/GxLwKf9CheBFBwasNjnf9fr7BGRSpSXGKMF6k+vxx4aupsaMK4Ry6/XZIoxrLuGjFMBfU77Z0ljo2bolo0Epoz3uCJUwonB+UquT9S/1b8DZs6jb1I5HibzE=;
X-YMail-OSG: Oi1QNd0VM1kzm_KEj_qt32KjE.LEC1Vuntcqg6pp0S1338CJnLk9ve..MATPaQOf6nctEKDw95CO08S4I0XvUUX9XhJkYE54FN1o5QH2MpgZcSCh6XPbDwRlQ.o-
Date: Sat, 29 Mar 2008 21:55:19 +0100 (CET)
From: Michael Meyer <mike65134@yahoo.de>
Subject: Re: performance differences: "maxcpus=1" vs. "echo 0 > /sys/devices/system/cpu/cpu1/online"
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080328135946.GB4404@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <954006.94043.qm@web25815.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Pavel Machek <pavel@ucw.cz> schrieb:

> On Tue 2008-03-25 14:47:50, Michael Meyer wrote:
> > Hi, 
> > 
> > what is the difference between booting a dual core
> > machine with "maxcpus=1" or by deactivating the second
> > core at run time with "echo 0 >
> > /sys/devices/system/cpu/cpu1/online"?
> 
> maxcpus=1 : core stays powered off
> 0 > online : core enters halt.
> 
> > I observed a funny behaviour of apache ant: although
> > it uses javac which is single threaded, a compile run
> > with "maxcpus=1" is actually faster than a compile run
> > with both cores activated. But with the second core
> > deactivated using "echo 0 >
> > /sys/devices/system/cpu/cpu1/online" it is even slower
> > than with both cores.
> 
> Thermal fun? Check cooling.

I have an extremely well cooled case and a Thermaltake Typhoon sitting
on the E6600 (Intel TDP 65 Watt). At a room temperature of 20°C both
cores idle at 21°C and after one hour of two instances of prime95
running they are both at 28-33°C. As the E6600 is specified until 60°C
(I believe), this should prevent any thermal throttling?
 
> > Is here any method to get the exact same behaviour of
> > "maxcpus=1" with disabling the second core only
> > temporarily? So that the second core could be disabled
> > before the ant execution and enabled after the ant
> > execution?
> 
> Patch pushing 0 > online cores into C4 would be nice.
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures)
> http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 



      E-Mails jetzt auf Ihrem Handy.
www.yahoo.de/go

