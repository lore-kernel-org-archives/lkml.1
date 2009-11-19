Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbZKSPqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbZKSPqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 10:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756971AbZKSPqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 10:46:42 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:44169 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882AbZKSPql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 10:46:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=OiGHlpawUu/qkZbzU/JtKFzQRhovqA0vCh8MlorkKrVqr6CjZk/Yu7BoHRjJg1Bjzd
         pYeOlcYlk6mCDoB8kWBkxwzdAh3T16y12J27Ek3RwhYV2GXNkPN2LFFPJe/fv1uO+/Gq
         gKI9wATbEzoRJ/8dYyMhhG6BeC7Y++el6bhw8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Date: Thu, 19 Nov 2009 16:45:29 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <200911191550.25476.bzolnier@gmail.com> <20091119152245.479dc38d@lxorguk.ukuu.org.uk>
In-Reply-To: <20091119152245.479dc38d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911191645.29885.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 November 2009 16:22:45 Alan Cox wrote:
> > If you know about other drivers still using ->pre_reset for cable detection
> > please let us know because they need fixing ASAP.
> > 
> > ->cable_detect method is there for a reason,
> 
> Given that I added it I may know more about it than you do. In fact from
> the rubbish you spout below it seems I do.

lol, I always heard that debugging other people's code is harder than
writing it in the first place..

> > already have a buggy cable detection (since ->pre_reset ignores the mandatory
> 
> Wrong.

You cannot know it unless you know how chip operates internally.  That's it.

You are taking chances that the controller does what most of similar hardware
do.  Unfortunately we have seen so many counterexamples of this in the past
(i.e. I wouldn't be so surprised if some hosts just snoop IDENTIFY data to get
their cable info) that I prefer to stick to safe approaches.

Especially since it cost us nothing and provides additional benefit of having
coherent API.

> > by spec part of cable detection which is probing slave before master) and
> 
> Have a free hint. If the host detects the cable type then we don't ask
> the drive. See the standard if you don't understand why. Even if we
> didn't the code would still be correct because we properly evaluate
> the speed configuration from all the data sources.

Please spare your 'free hints' and preaching tone.   You've completely failed
over four years span to out do the messy code even with like ~1.5 year handicap
to finalize the hostile takeover.

I'm completely fed up with the process and I'm simply fixing up your mess now,
50+ patches and counting.  Turns out to be order of magnitude more productive
than even trying to discuss things with you and/or your influential friends.

-- 
Bartlomiej Zolnierkiewicz
