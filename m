Return-Path: <linux-kernel-owner+w=401wt.eu-S1759742AbXGaRCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759742AbXGaRCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbXGaRCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:02:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:11268 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbXGaRCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:02:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rCo+JZkStCvl2rhE2v6fWA/grpKtMwQS+WIV7R2ypmPXMyp5j+FRGZyg3A1VF7NHHBrqpEcq5NC51LUI54Fm+Esy+7JW/J/0rJC09/5qEzPhKvbJSwoB68i67/5UB3DfvxyeZdSB5Qqz5KTECpr2now0CYLc/h0cmEczmzFs7SE=
Message-ID: <b21f8390707311002h3dcfca31kf94265683683bc68@mail.gmail.com>
Date: Wed, 1 Aug 2007 03:02:19 +1000
From: "Matthew Hawkins" <darthmdh@gmail.com>
To: "Miguel Figueiredo" <elmig@debianpt.org>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Cc: ck@vds.kolivas.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kasper Sandberg" <lkml@metanurb.dk>
In-Reply-To: <200707311723.51387.elmig@debianpt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <200707311432.45214.elmig@debianpt.org>
	 <b21f8390707310857q7d878fe1yc5351cce2cc74248@mail.gmail.com>
	 <200707311723.51387.elmig@debianpt.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/07, Miguel Figueiredo <elmig@debianpt.org> wrote:
> Have you tryied the 2 modes of the patch?

Here's my stats for sched_yield_ctl = 2

loops  fps
0       48
1       48
2       48
3       48
4       39
5       39
6       39
7       28
8       28
9       22
10     18

Once again it was very jerky come run-around-the-map time, though it
improved over time.
For me, still not as smooth as CFS was (especially the initial player
movement, which was the worst by far of any test so far)

I want to get some better numbers than plain fps though, the graph of
the numbers is more staircase-like in this test but what it doesn't
show is exactly what's going on.  I can assure you the framerates may
be similar but the gameplay isn't - and in this test 5fps difference
is meaningless since it jumps around a lot (especially during the
run-around) as you would expect with the different stuff needing to be
rendered.

-- 
Matt
