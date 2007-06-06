Return-Path: <linux-kernel-owner+w=401wt.eu-S965475AbXFFX2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965475AbXFFX2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935714AbXFFX2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:28:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:19036 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935667AbXFFX17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:27:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="236413904"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Wed, 6 Jun 2007 16:27:46 -0700
User-Agent: KMail/1.9.6
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200706061229.24486.jesse.barnes@intel.com> <200706061620.10627.jesse.barnes@intel.com> <Pine.LNX.4.64.0706061923470.2716@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706061923470.2716@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061627.46421.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 6, 2007 4:24 pm Justin Piszcz wrote:
> > The mem= approach though looks slightly off, but I haven't looked
> > at x86_64's mem= handling to see why.  From a high level though,
> > adjusting end_pfn is the right thing to do, since theoretically
> > mem= could choose to make holes in your low memory and keep your
> > high memory in the allocation pools (though it's not generally
> > implemented this way).
> >
> > Jesse
>
> Ahh, ok!  Sounds great, I will keep running the kernel with your
> patch without mem= and let you know if I see any issues.
>
> Chances of getting this into 2.6.22-rc5?

I'm not sure it's appropriate for -rc5 since it mucks around with some 
early boot ordering, but I'll leave that to Andi, since it does address 
some real bugs people have been seeing.

Can we add your "Tested-by:  Justin Piszcz <jpiszcz@lucidpixels.com>" to 
the patch? :)

Thanks,
Jesse
