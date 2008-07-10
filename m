Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbYGJK5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbYGJK5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 06:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbYGJK5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 06:57:32 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:55927 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbYGJK5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 06:57:30 -0400
X-BigFish: VPS-4(zz98dR62a3L7efVzz10d3izzz32i6bh87il43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3SEFE-02-HXL-01
Date: Thu, 10 Jul 2008 12:57:12 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86/pci: Broken build for X86_VISWS
Message-ID: <20080710105712.GL7963@erda.amd.com>
References: <20080710095757.GB5607@erda.amd.com> <20080710102305.GA20096@elte.hu> <20080710104216.GK7963@erda.amd.com> <20080710104446.GA3131@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080710104446.GA3131@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 10 Jul 2008 10:57:13.0791 (UTC) FILETIME=[B5BBFCF0:01C8E27B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.07.08 12:44:46, Ingo Molnar wrote:
> i'm wondering why you werent hit by the generic-ipi build bug. Perhaps 
> you had SMP disabled?

No:

$ grep 'SMP\|VISWS' configs/linux-i386-visws.config 
CONFIG_X86_SMP=y
CONFIG_X86_32_SMP=y
CONFIG_SMP=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_VISWS=y
# CONFIG_X86_VSMP is not set
CONFIG_X86_VISWS_APIC=y

Probably it is because I am on the tip/x86/unify-pci tree where the
IPI changes were not in.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

