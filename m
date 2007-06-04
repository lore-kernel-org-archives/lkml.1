Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbXFDQBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbXFDQBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbXFDQBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:01:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:32811 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbXFDQBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:01:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=l3RvfykleHUri7ar0hC7++CoeIejYHrmK8VYLK+n8ZjP5rJvHR5UbBX6LE3MckKh7h52pAiIKh/3C9OX31KXqUVQrT1xsdaoB1lbw1O/3kogTvVi388VWUveiJcQ2GYzYB0n6rFFMob6UUn3Zi5VNqU5B1ZpLnhO3ikaCIG1JVw=
Message-ID: <2c0942db0706040901n473afb20x800cb489e3f7732b@mail.gmail.com>
Date: Mon, 4 Jun 2007 09:01:06 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Matt Keenan" <tank.en.mate@gmail.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Venki Pallipadi" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706041149160.18306@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan>
	 <Pine.LNX.4.64.0706021610210.19116@p34.internal.lan>
	 <4662869A.9030700@gmail.com>
	 <200706040840.21593.jbarnes@virtuousgeek.org>
	 <2c0942db0706040848y1d1c2ce9p521c65117244edf1@mail.gmail.com>
	 <Pine.LNX.4.64.0706041149160.18306@p34.internal.lan>
X-Google-Sender-Auth: 1c72fef7f5d08a66
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> On Mon, 4 Jun 2007, Ray Lee wrote:
> > Ick. Systems that used to boot fine would then panic on a kernel
> > upgrade. That's rather rude for a condition that's merely an
> > optimization (using all memory), rather than one of correctness. A
> > panic seems entirely inappropriate.
>
> While I am unsure of the 'best' solution, if they boot and it does not
> panic but takes 10 minutes to boot, people are going to seriously wonder
> what is going on?

<goes and re-reads thread more carefully> Oh, hmm.

I think a big fat warning with asterisks in the bootup is a good
thing, but panicking when there's no need is never a good idea. If the
system takes that long to boot up, I'm certain the first thing they'll
do is to type dmesg | less to look for anomalies.

Ray
