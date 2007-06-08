Return-Path: <linux-kernel-owner+w=401wt.eu-S968893AbXFHLcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968893AbXFHLcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 07:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968558AbXFHLch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 07:32:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:1289 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968505AbXFHLcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 07:32:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=R5DD0EQnxhFvT3Kber0ERBze4kQY40VhB/T0GrBDHlD9d9Y80X1S+3hvb22KZq2seCD+CSo7QbkPd5Mt+bhm6OQAM8fwazx864fqb0MeQYaWrkggDG6/L45rsyNalBoKypfpI8/472qnV/G/q2VGZgsUFTxRYKOyMJz/DyFk4HU=
Message-ID: <46693E33.6080705@gmail.com>
Date: Fri, 08 Jun 2007 20:32:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Re: Linux v2.6.22-rc3
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>	<9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>	<466196AD.3090502@garzik.org>	<9d2cd630706031046n2bd77585o7c0df1c5fea5167f@mail.gmail.com>	<46667466.4010500@gmail.com>	<9d2cd630706062322v2d73b32dp1da56f97e2069fff@mail.gmail.com>	<4667B347.9040900@gmail.com>	<alpine.LFD.0.98.0706071352440.4205@woody.linux-foundation.org>	<20070607224746.GA23290@havoc.gtf.org>	<46690D10.9040808@gmail.com> <20070608122750.7f8ae0e0@the-village.bc.nu>
In-Reply-To: <20070608122750.7f8ae0e0@the-village.bc.nu>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Upto 2.6.21, if the same condition triggers, it delays 30secs and just
>> continue, so I don't think it was a worthy protection against ghost
>> devices or TF malfunction.  The only protection it offers is preventing
>> libata from accessing slave's status register too early.  SRST sequence
>> looks like the following.
> 
> I've seen no bug where it looked like it saved something, and the only
> ghost device bugs I've seen it failed to detect anyway (hence the PCMCIA
> drivers own ghost detection logic)

If we still have several rc's left, how about just removing it and
watching the fireworks?  Jeff?

-- 
tejun
