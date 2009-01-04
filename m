Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbZADApV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbZADApV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbZADApF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:45:05 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:49657 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZADApE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:45:04 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=Q-dwGeL8sa5jDpqtoqcA:9 a=Y2AOqPqU_Gc-k7zNrVmhbcX7HLcA:4 a=QX8__OZuf2QA:10 a=DS8z0TzW9AIA:10
Message-ID: <4960068A.3040109@shaw.ca>
Date: Sat, 03 Jan 2009 18:44:58 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.embedded,gmane.linux.kernel
To: Rob Landley <rob@landley.net>
CC: Matthieu CASTET <matthieu.castet@parrot.com>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
References: <200901020207.30359.rob@landley.net> <200901020513.19593.rob@landley.net> <495E3AF8.6000006@parrot.com> <200901031346.01325.rob@landley.net>
In-Reply-To: <200901031346.01325.rob@landley.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> For the record, the reason I can't just pregenerate all these suckers on a 
> system that's got an arbitrary precision calculator (ala dc) and then just 
> ship the resulting header files (more or less the what the first version of 
> that first patch did) is that some architectures (arm omap and and arm at91) 
> allow you to enter arbitrary HZ values in kconfig.  (Their help text says that 
> in many cases values that aren't powers of two won't work, but nothing 
> enforces this.)  So if we didn't have the capability to dynamically generate 
> these, you could enter a .config value that would break the build.

Is there a good reason that these archs allow you enter arbitrary HZ 
values? The use case for using custom HZ values at all nowadays seems 
fairly low now that dynticks is around (if that arch supports it 
anyway), let alone being able to specify wierd obscure values for it. 
Especially if nothing can ensure that all values it allows will actually 
result in a functional kernel..
