Return-Path: <linux-kernel-owner+w=401wt.eu-S1031598AbXEAIkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031598AbXEAIkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031597AbXEAIkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:40:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:53061 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031600AbXEAIkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:40:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GquzkKR0QHXFCzoSHtDs9r24od3X/WN3yvSgYaWiRhczfqcNlbQhQOVTyYm0zOivIux/bcIwwhob7CPtNevRas3ecmFci4Wv6KjnOWOhUOFHZy26NRhMgF9lgvAKPOUnXXTus8GIsslQVb7SJc2gfkQNzBLAIpJOYxXFKJPcyhg=
Message-ID: <4636FCE3.6000405@gmail.com>
Date: Tue, 01 May 2007 10:40:03 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-mm1: many processes end up in D state
References: <46360DA7.6040003@gmail.com>	<20070430110510.1f559d34.akpm@linux-foundation.org>	<4af2d03a0704301114sc84b358td8781c91b8564c38@mail.gmail.com> <20070430114449.1dad1ab2.akpm@linux-foundation.org>
In-Reply-To: <20070430114449.1dad1ab2.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> I would check the anticipatory scheduler as well, please.  I don't know
> what no-op would do with a workload like that, but it probably isn't very
> good.
> 
> You appear to believe that it's related to the CPU scheduler?  

Oh, no. I have really no idea, what may cause this :).

> That's a bit
> unexpected - it sounds more like a VFS/IO thing?  But stranger things have
> happened.

I think so.

> I guess it's time to end the staircase experiment in -mm. 
> http://userweb.kernel.org/~akpm/js.bz2 is my current rollup (against
> 2.6.21) minus staircase and related things.  Pretty please.

Anticipatory + -js is no change. Going to try vanilla and in both cases whether
it works or not, I'll bisect either -mm or vanilla.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
