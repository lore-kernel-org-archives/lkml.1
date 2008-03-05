Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYCEPgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYCEPgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbYCEPge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:36:34 -0500
Received: from mga06.intel.com ([134.134.136.21]:29395 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753302AbYCEPgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:36:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,451,1199692800"; 
   d="scan'208";a="260950977"
Message-ID: <47CEBDC2.4070608@linux.intel.com>
Date: Wed, 05 Mar 2008 07:35:30 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>, hans.rosenfeld@amd.com,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu> <47CC2A3D.1000307@linux.intel.com> <20080303174009.GA19131@elte.hu> <47CC451A.2060501@linux.intel.com> <alpine.LFD.1.00.0803031042230.17889@woody.linux-foundation.org> <47CC74E6.60306@linux.intel.com> <47CCA03D.9040007@linux.intel.com> <20080304065305.GA32287@elte.hu>
In-Reply-To: <20080304065305.GA32287@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Arjan van de Ven <arjan@linux.intel.com> wrote:
> 
>>> I'm staring at the disassembly and it's quite different but 
>>> follow_page() is rather large; trying to make a smaller testcase now
>> sadly a more isolated testcase doesn't show the same behavior yet; so 
>> it's some fun interaction ;(
>>
>> more staring at the assembly for me
> 
> could you post the "bad" and the "good" disassembled functions, and the 
> specific gcc version string?
> 

http://www.fenrus.org/memory.asm.macro   <-- failing one
http://www.fenrus.org/memory.asm.inline   <-- working one
