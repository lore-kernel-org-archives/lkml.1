Return-Path: <linux-kernel-owner+w=401wt.eu-S1751733AbXBDCmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbXBDCmz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 21:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXBDCmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 21:42:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:54231 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbXBDCmy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 21:42:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 4/4] Add support to OProfile for profiling Cell BE SPUs -- update
Date: Sun, 4 Feb 2007 03:42:39 +0100
User-Agent: KMail/1.9.5
Cc: Maynard Johnson <maynardj@us.ibm.com>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <45BE4ED0.5030808@us.ibm.com> <200702030840.06270.arnd@arndb.de> <45C4EA7D.4000709@us.ibm.com>
In-Reply-To: <45C4EA7D.4000709@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702040342.39626.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX19MF+1N6hU8ue5wRfcKU7oEBuGqx6iUhkbFb+RpHU/HSb+7WQBtrZhpCTFMpcQuT8PdgqmVp5ktlBqK2EkadSsigDbZlmcFTOcxJ4Mi6p6eaA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 February 2007 21:03, Maynard Johnson wrote:
> I presume you mean 'object_id'. 

Right, sorry for the confusion.

> What you're asking for is a new  
> requirement, and one which I don't believe is achievable in the current 
> timeframe.  Since this is spufs code that's dynamicaly loaded into the 
> SPU at runtime, the symbol information for this code is not accessible 
> to the userspace post-processing tools.

We can always fix the user space tool later, but it is important to
get at least the kernel interface right, so we can add the functionality
later without breaking new user space on old kernels or vice versa.

> It would require an altogether  
> different mechanism to record samples along with necessary information, 
> not to mention the changes required in the post-processing tools.  This 
> will have to be a future enhancement.

So what do you do with the samples for object_id == 0? I would expect them
to be simply added to the sample buffer for the kernel, which is sort
of special in oprofile anyway.

	Arnd <><
