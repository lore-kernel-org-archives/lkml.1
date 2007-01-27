Return-Path: <linux-kernel-owner+w=401wt.eu-S1752367AbXA0Tjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbXA0Tjf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 14:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbXA0Tjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 14:39:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:16106 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbXA0Tjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 14:39:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,246,1167638400"; 
   d="scan'208"; a="173733170:sNHT19011279"
Message-ID: <45BBAA74.8090809@intel.com>
Date: Sat, 27 Jan 2007 11:39:32 -0800
From: Auke Kok <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Auke Kok <auke-jan.h.kok@intel.com>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: Possible regression: MSI vector leakage since 2.6.18-rc5ish (Unable
 to repeatedly allocate/free MSI interrupt)
References: <45BA82DA.6050201@intel.com>	<m1bqkku8bp.fsf@ebiederm.dsl.xmission.com> <45BBA2DD.50609@intel.com> <m1veiss1zr.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1veiss1zr.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Auke Kok <auke-jan.h.kok@intel.com> writes:
> 
>> I highly doubt it - I've seen the problem even on this weeks git on
>> x86_64. Moreover, I'm at home for the weekend and testing resources are limited
>> :). I'll see what I can do
> 
> Thanks.  There may be more to it than what I suspect, but I could not
> reproduce it on x86_64.
> 
> Now I may have missed something as I optimized my tested based on the fact
> that close and open are triggered when you up and down a network interface.
> so I didn't do a complete rmmod, (since my network driver wasn't modular).
> 
> Since you have seen this on x86_64 I will look deeper.  

gah, strike that.

my only x86_64 system here survived the test with latest git tree.

my 386 system here has no msi devices and I can't reinstall my x86_64 system 
since it's headless, so I can't test anything until monday. I'll give it a full 
test again and see which 2.6.20rc kernels did fail, most likely a much older 
tree (I suspect).

Auke
