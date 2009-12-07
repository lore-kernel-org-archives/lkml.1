Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbZLGGSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbZLGGSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 01:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZLGGSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 01:18:37 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40190 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbZLGGSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 01:18:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V+lSTjCoXo5XozUU7paAmYBHHxYROYbgSyFnEAuthuY47ke25mIBxyhktvBOVEA2EQ
         2Bws7RRl7va7cInz5v7KZsS5X2l5mnQ8ny1TsbnkycX0GcZxwSXa2EX/yoD3VFLsUmHy
         hREyRZxcqIKFcKD3Hryz1/5HW5N0Y+OnGxjbY=
Date: Mon, 7 Dec 2009 07:18:40 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/2] perf: Make location of kernel source configurable
Message-ID: <20091207061839.GB5186@nowhere>
References: <20091206307.542816612@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091206307.542816612@firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 06, 2009 at 03:07:30PM +0100, Andi Kleen wrote:
> 
> tools/perf has no support for separate object directories
> and lots of hard coded paths assuming that the kernel source
> is always in ../..
> 
> As a first step of compiling it separately without messing
> up clean source trees allow to configure the kernel source
> location using a KERNELSRC variable 
> 
> This allows at least to copy the whole tools/perf
> directory elsewhere and build it separately.
> 
> The default is still ../.., so for a standard build
> nothing changes
> 
> This also removes a lot of ugly ../.. from the source.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>


It does not apply cleanly, it seems you are using 2.6.32
There have a been a lot of updates in this merge window.

Could you please resend against latest linus tree?

Thanks.

