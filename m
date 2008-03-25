Return-Path: <linux-kernel-owner+w=401wt.eu-S1760606AbYCYXI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606AbYCYXI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbYCYXIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:08:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:43242 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169AbYCYXIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:08:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z/ujXmYSJ1rspus/axnrYcwe+9l3LTriOF2nUzkYK4KVTCq6zYv0TbG5XRvfQ2Cc239M0xpc/JV5SZv7571cUNiyZEq8NZ1hGgcVZWpOsfMid+TCbQ0SfmYrMW5prLqQAyphk9B8DfUZ88NojdO+KMK8rjnfIcONRKxtsyPY5HY=
Message-ID: <86802c440803251608v6f09f531x57d9688601cc84fd@mail.gmail.com>
Date: Tue, 25 Mar 2008 16:08:50 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: pat cpu feature bit setting for known cpus
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Venki Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "kernel list" <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com
In-Reply-To: <47E98572.704@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803242324.35357.yhlu.kernel@gmail.com>
	 <47E9003B.5010002@zytor.com>
	 <86802c440803251103taf4c8f2mb674c3d17f3c2345@mail.gmail.com>
	 <20080325190851.GC30998@linux-os.sc.intel.com>
	 <20080325200830.GB15330@elte.hu> <47E962AE.9040307@zytor.com>
	 <47E9843A.1060702@zytor.com>
	 <86802c440803251605w7021b60cmbc312eb9ca87d277@mail.gmail.com>
	 <47E98572.704@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 4:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>  >>
>  >>  By the way, I want to clarify: I didn't mean it was *intended* as
>  >>  vendor-lockin, just that it's an undesirable effect of this.
>  >
>  > if the PAT works, we may need to trim the memory according to MTRR, right?
>  >
>
>  That doesn't seem like it's specific to PAT?

could page table to  set WRBACK the range that is not covered by MTRR in e820..

YH
