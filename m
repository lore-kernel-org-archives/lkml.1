Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbYGJKmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbYGJKmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 06:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYGJKmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 06:42:38 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:36076 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbYGJKmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 06:42:37 -0400
X-BigFish: VPS-6(zz98dR62a3L7efVzz10d3izzz32i6bh87il63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3SDQM-02-HI1-01
Date: Thu, 10 Jul 2008 12:42:17 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86/pci: Broken build for X86_VISWS
Message-ID: <20080710104216.GK7963@erda.amd.com>
References: <20080710095757.GB5607@erda.amd.com> <20080710102305.GA20096@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080710102305.GA20096@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 10 Jul 2008 10:42:20.0170 (UTC) FILETIME=[A1183EA0:01C8E279]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.07.08 12:23:05, Ingo Molnar wrote:
> well spotted. Does the patch below fix it for you?

Yes, it should. I send out a fix with the same change and it builds
well. But I did not realize that X86_VSMP was also affected.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

