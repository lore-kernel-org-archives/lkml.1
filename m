Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbYIYTc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbYIYTc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYIYTcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:32:51 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:14699 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbYIYTcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:32:50 -0400
X-BigFish: VPS-35(zz1432R98dR936eQ62a3L1805Mzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7RNM3-01-8PH-01
Date: Thu, 25 Sep 2008 21:32:28 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net
Subject: Re: oprofile: Implement Intel architectural perfmon
Message-ID: <20080925193228.GH23557@erda.amd.com>
References: <1219250433-25516-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1219250433-25516-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Sep 2008 19:32:33.0875 (UTC) FILETIME=[75592230:01C91F45]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

I have uploaded all pending OProfile patches to my kernel.org
repository. As we already talked about this, there are changes in that
implement model specific init/exit functions. Please change your patch
in a way that it uses these functions. This will make your
implementation cleaner. I will also send some more comments to the
patches itself. It would help me if you could send the new patches
relative to my tree.

Thanks a lot,

-Robert

On 20.08.08 18:40:29, Andi Kleen wrote:
> 
> This patchkit implements architectural perfmon support in oprofile.
> This allows to do generic profiling of a few standard events in all 
> newer Intel CPUs, including Atom and Nehalem. The CPU describes
> its event in CPUID so they can be used without knowing anything
> about the CPU.
> 
> The code requires some changes to the oprofile userland, which
> I am posting separately to the oprofile list.
> 
> -Andi
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

