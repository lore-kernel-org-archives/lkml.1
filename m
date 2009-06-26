Return-Path: <linux-kernel-owner+w=401wt.eu-S1761125AbZFZTER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125AbZFZTER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZFZTED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:04:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:31206 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbZFZTED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:04:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,297,1243839600"; 
   d="scan'208";a="528153358"
Message-ID: <4A451BA4.4090000@linux.intel.com>
Date: Fri, 26 Jun 2009 12:04:04 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/9] x86: introduce a set of platform feature flags
References: <43F901BD926A4E43B106BF17856F07556412B7E1@orsmsx508.amr.corp.intel.com> <20090626154731.GA3153@elte.hu>
In-Reply-To: <20090626154731.GA3153@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> Btw., this enumeration of basic PC features isnt bad in itself - and 
> if there's a boot-flag based detection method (like on MRST) then 
> this can convey a 'should this platform driver attempt to 
> initialize' information to the driver, and rather cleanly so.
> 

That is the whole point of this, yes.  Furthermore, it is expected that
we *also* would be able to set platform flags based on early probes.

> But there's bad uses of this as well, and those bad uses seem to 
> dominate this patch-set.

Not entirely surprising, since this stuff is more or less randomly
sprinkled through the existing code.  We have a huge bunch of legacy
code and yes, it needs cleanup.

This is a huge opportunity, of course, but it's going to be a lot of
work.  A lot of this is likely to overlap directly with the needs of
Xen, too.

	-hpa
