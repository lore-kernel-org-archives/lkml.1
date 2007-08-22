Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbXHVHU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbXHVHU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 03:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbXHVHUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 03:20:19 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:9049 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbXHVHUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 03:20:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cq72yfIxJK7jPgto59t+vW2l+j1/67ED3keZ90sNLxB77mMw2chSEh5MmS/P1wZ51aR1Xx7UXQXTuQ609cWDnvAOeo8oyPrIlX38hcltZQVLeS6fpGoS1W53FaO+jsfvsizFUOmg+Y3LVwWuyM22ZjRYpUOpBHZlHXWItIRBaSg=
Message-ID: <86802c440708220020u14c49a33r668228b6064e9631@mail.gmail.com>
Date: Wed, 22 Aug 2007 00:20:14 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Huang, Ying" <ying.huang@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Chandramouli Narayanan" <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, "Aaron Durbin" <adurbin@google.com>
In-Reply-To: <20070822012216.GN32640@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1187250664.15063.0.camel@caritas-dev.intel.com>
	 <1187313920.28497.1.camel@caritas-dev.intel.com>
	 <46C5C8C4.4060407@zytor.com>
	 <1187580031.27947.67.camel@caritas-dev.intel.com>
	 <46C9CB89.7020603@zytor.com> <20070821113310.GF32640@bingen.suse.de>
	 <46CAC168.7090102@zytor.com> <20070821114548.GI32640@bingen.suse.de>
	 <86802c440708211658j1fb2a8caj41e1bb8bffa4baf4@mail.gmail.com>
	 <20070822012216.GN32640@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/07, Andi Kleen <ak@suse.de> wrote:
> > current LinuxBIOS's path: the elfboot in LinuxBIOS will prepare the
> > e820 table, and jump to startup_32 in kernel. is that not good and
> > simple?
>
> The problem is that the zero page cannot be changed at all in this
> setup. Or rather it can be only changed by breaking LinuxBios.

FYI.

current mkelfImage is using
#define REAL_MODE_DATA_LOC      0x20000
the %esi will be 0x20000

YH
