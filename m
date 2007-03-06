Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbXCFFEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbXCFFEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 00:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbXCFFEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 00:04:12 -0500
Received: from smtp102.rog.mail.re2.yahoo.com ([206.190.36.80]:40873 "HELO
	smtp102.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752874AbXCFFEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 00:04:11 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2007 00:04:11 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-YMail-OSG:From:Organization:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FoMYe8IimwGNo/jF8NVTgL6pP303tt0Fmd3NEoBNlrxDqMjWtdNqlqlazMjHpKbEw4dmMz75cQ3vl6j5b0Qe1vidPlNiGq05KwIkJTQhXZtXqYehkRFWdIl85/Ofudf2wMozEW3okvFX1COUN9UmNc9CKbzEI2bMpDBrhCOXEZc=  ;
X-YMail-OSG: aTxQbhAVM1mbXVAMP5Ni4aUsK8JN0g5U2p3C87.cnSfIFPKP_9h1MGW.kVJnfuKpow--
From: Shawn Starr <shawn.starr@rogers.com>
Organization: sh0n.net
To: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Mon, 5 Mar 2007 23:57:19 -0500
User-Agent: KMail/1.9.5
Cc: Con Kolivas <kernel@kolivas.org>, Willy Tarreau <w@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703052357.20035.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007 10:13, Willy Tarreau wrote:
> Con,
>
> I've now given it a try with HZ=250 on my dual-athlon. It works
> beautifully. I also quickly checked that playing mp3 doesn't skip during
> make -j4, and that gears runs fairly smoothly, since those are the
> references people often use.
>
> But with real work, it's excellent too. When I saturate my CPUs by
> injecting HTTP traffic on haproxy, the load is stable and the command line
> perfectly responsive, while in the past the load would oscillate and the
> command line sometimes stopped to respond for a few seconds.
>
> I've also launched my scheddos program (you may remember, the one we did a
> few experiments with). I could not cause any freeze at all. Plain 2.6.20
> had already improved a lot in this area, but above 4 processes/CPU,
> occasional short freezes did still occur. This time, even at 100 processes,
> the system was rather slow (of course!) but just as expected, and nothing
> more.
>
> I also tried the good old "dd if=/dev/zero bs=1|...|dd bs=1 of=/dev/null"
> and it did not cause any trouble.
>
> I will boot 2.6 slightly more often to test the code under various
> conditions, and I will recommend it to a few people I know who tend to
> switch back to 2.4 after one day full of 2.6 jerkiness.
>
> Overall, you have done a great job !
>
> I hope that more people will give it a try, first to help find possible
> remaining bugs, and to pronounce in favour of its inclusion in mainline.

Hi Con/Willy, 

Just to chime on this thread, I've been testing Con's scheduler patches since 
he mentioned them to me. I have to say for desktop performance all processes 
running remain responsive (although with more resource hungry processes 
things get slower but remain responsive, but expected).  I have also been 
testing his scheduler on my work power workstation running 4 VMs with 4GB of 
ram on a dual-core EM64T box, again RSDL performs rather well balancing VM 
resources even while I have xmms running, xchat, beryl and a bunch of other 
stuff.  There is total response to each process.

Thanks, 
Shawn.
