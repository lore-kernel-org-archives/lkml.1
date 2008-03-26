Return-Path: <linux-kernel-owner+w=401wt.eu-S1759831AbYCZABW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbYCZABW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 20:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbYCZABO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 20:01:14 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:34209 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbYCZABM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:01:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I3+HXD1JX9GZ+WckxzKyLh+O27ydIkqS6RnvD8KJNhDc8DJeH+MnHLyHwJVlUGYe9CX1ITBUg7a3TwmdO2Rw5Q+uF/BK/FM2aiM2iqXj7C9EX/iOCW+uXSU1D6a9+yXPrXa3BTsX6p2qCBJxwLyAWv3KF6tjig//p2evNmWNEmc=
Message-ID: <86802c440803251701s125ce73dp3c5c03aa4a9e89ef@mail.gmail.com>
Date: Tue, 25 Mar 2008 17:01:12 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: pat cpu feature bit setting for known cpus
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEC3E1EB@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803242324.35357.yhlu.kernel@gmail.com>
	 <86802c440803251103taf4c8f2mb674c3d17f3c2345@mail.gmail.com>
	 <20080325190851.GC30998@linux-os.sc.intel.com>
	 <20080325200830.GB15330@elte.hu> <47E962AE.9040307@zytor.com>
	 <47E9843A.1060702@zytor.com>
	 <86802c440803251605w7021b60cmbc312eb9ca87d277@mail.gmail.com>
	 <47E98572.704@zytor.com>
	 <86802c440803251608v6f09f531x57d9688601cc84fd@mail.gmail.com>
	 <924EFEDD5F540B4284297C4DC59F3DEEC3E1EB@orsmsx423.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 4:38 PM, Pallipadi, Venkatesh
<venkatesh.pallipadi@intel.com> wrote:
>
>
>
>  >-----Original Message-----
>  >From: Yinghai Lu [mailto:yhlu.kernel@gmail.com]
>  >Sent: Tuesday, March 25, 2008 4:09 PM
>  >To: H. Peter Anvin
>  >Cc: Ingo Molnar; Pallipadi, Venkatesh; Thomas Gleixner; Andrew
>  >Morton; kernel list; Siddha, Suresh B
>  >Subject: Re: [PATCH] x86: pat cpu feature bit setting for known cpus
>  >
>  >On Tue, Mar 25, 2008 at 4:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>  >> Yinghai Lu wrote:
>  >>  >>
>  >>  >>  By the way, I want to clarify: I didn't mean it was
>  >*intended* as
>  >>  >>  vendor-lockin, just that it's an undesirable effect of this.
>  >>  >
>  >>  > if the PAT works, we may need to trim the memory
>  >according to MTRR, right?
>  >>  >
>  >>
>  >>  That doesn't seem like it's specific to PAT?
>  >
>  >could page table to  set WRBACK the range that is not covered
>  >by MTRR in e820..
>  >
>
>  Trimming of e820 memory is already done by Jesse's patch here
>  commit 99fc8d424bc5d80
>  Are you referring to similar thing?
>
Yes.

YH
