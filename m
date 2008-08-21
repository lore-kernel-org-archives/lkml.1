Return-Path: <linux-kernel-owner+w=401wt.eu-S1757918AbYHUNaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbYHUNaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbYHUNa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:30:26 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:29183 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbYHUNaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:30:25 -0400
X-BigFish: VPS-21(zz98dR936eQ62a3Lzz10d3izzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K5YDIB-02-GBW-01
Date: Thu, 21 Aug 2008 15:29:53 +0200
From: Robert Richter <robert.richter@amd.com>
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: patch "x86: MOVE PCI IO ECS code to x86/pci" breaks CPU hotplug
Message-ID: <20080821132952.GD13011@erda.amd.com>
References: <48AD82D5.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <48AD82D5.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 21 Aug 2008 13:30:14.0535 (UTC) FILETIME=[0B3BD970:01C90392]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.08.08 13:59:33, Jan Beulich wrote:
> Even worse - this would even try to access the MSR on non-AMD CPUs
> (currently probably prevented just by the fact that only AMD ones use
> family values of 0x10 or higher).

Ups, really worse. Code was AMD specific before and became
generic. Will fix this.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

