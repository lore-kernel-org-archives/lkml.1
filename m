Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbYARGey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbYARGey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 01:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYARGer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 01:34:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41048 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYARGeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 01:34:46 -0500
Message-ID: <479046BA.7090903@zytor.com>
Date: Fri, 18 Jan 2008 01:27:06 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make clflush a required feature on x86_64
References: <20080118045921.GB974@phobos.i.cabal.ca> <p734pdbbrwu.fsf@bingen.suse.de> <20080118060124.GC1726@phobos.i.cabal.ca>
In-Reply-To: <20080118060124.GC1726@phobos.i.cabal.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> On Fri, Jan 18, 2008 at 06:53:53AM +0100, Andi Kleen wrote:
>> One problem that we had in the past is that some simulators
>> only implement the absolutely minimum feature set and you
>> might have well broken one of these with this.
> 
> Yeah, true. Please ignore the patch folks.
> 
> cheers,	Kyle

Simulators can be fixed, even if it takes time; for something like 
clflush this is easier since clflush can be implemented as a simple noop 
for most of them.

I just verified that Bochs 2.3.0 lacks this CPUID bit whereas the 
current version, 2.3.6, enables CLFLUSH iff SSE2 is enabled.  Qemu 0.9.0 
has CLFLUSH.  Andi, do you happen to know of any specific simulators 
which are problematic?  I would assume any recent version of SimNow is 
up to date.

	-hpa
