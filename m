Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbXFGJzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbXFGJzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 05:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXFGJzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 05:55:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:13613 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbXFGJzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 05:55:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JJeLqGQaWnNml5Q41aIwr62vSS0jlz8Alh8WVGKNa7O8HPMNX1OT6KpssGyPxnGBG1zUuBu2fBCe0dLzlE0ujvnmcAdkUrUcSRCgXgkBK51kWcuD/yoFVaEbzNj0EurfknH8zNtV3t15ahS6M/2Va6CZevGNznMPN0KkrBiL4og=
Message-ID: <a781481a0706070255i40b1a8e0l285315febcaa471c@mail.gmail.com>
Date: Thu, 7 Jun 2007 15:25:00 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Cc: "Jesse Barnes" <jesse.barnes@intel.com>,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070607085147.GC15226@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706061229.24486.jesse.barnes@intel.com>
	 <200706061620.10627.jesse.barnes@intel.com>
	 <Pine.LNX.4.64.0706061923470.2716@p34.internal.lan>
	 <200706061627.46421.jesse.barnes@intel.com>
	 <20070607085147.GC15226@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Andi Kleen <andi@firstfloor.org> wrote:
> On Wed, Jun 06, 2007 at 04:27:46PM -0700, Jesse Barnes wrote:
> > [...]
> > I'm not sure it's appropriate for -rc5 since it mucks around with some
> > early boot ordering, but I'll leave that to Andi, since it does address
> > some real bugs people have been seeing.
>
> I don't think the patch is suitable for merging at this time. Perhaps
> if it survives some time in -mm* / 2.6.23* it could be backported
> in a later 2.6.22 stable release. But right now it definitely
> needs more testing and addressing of my review comments.

BTW an unrelated/happy side-effect of the patch is that it removes
the zero-size-guilty kmalloc()'s from the mtrr code. -mm does have
some fixes that prevent those zero-size allocations, which could
likely be retired if this gets merged in? ...

[ On another unrelated note, could someone tell me who maintains
i386? I've looked around, but surprisingly can't seem to find
anybody listed anywhere. ]

Satyam
