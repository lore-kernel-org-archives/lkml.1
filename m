Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbZJECZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbZJECZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 22:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758327AbZJECZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 22:25:26 -0400
Received: from mail-pz0-f179.google.com ([209.85.222.179]:49510 "EHLO
	mail-pz0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758110AbZJECZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 22:25:26 -0400
MIME-Version: 1.0
In-Reply-To: <f488382f0910031754p7e29f6f9mc78dc9bc9b0c63b4@mail.gmail.com>
References: <f488382f0910031754p7e29f6f9mc78dc9bc9b0c63b4@mail.gmail.com>
Date: Sun, 4 Oct 2009 19:24:13 -0700
Message-ID: <f488382f0910041924p5e9eae48qa19afc81c43fca3d@mail.gmail.com>
Subject: Re: cpufreq scaling strangely, system feels warm
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 3, 2009 at 5:54 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> I have a system that's behaving as though it's under a moderate load,
> but nothing's happening and the load average is zero. If I change my
> cpufreq governor to 'conservative' or 'ondemand', the CPU immediately
> scales up to the maximum clock frequency (as though something was
> demanding that much power). The system is also very warm, which is
> abnormal even when the machine is always clocked at its maximum
> frequency.
>
> Top shows that there are no processes which are hogging the CPU, and
> /proc/interrupts doesn't reveal anything interesting (i.e. an
> interrupt storm). The only way to get my system to stay cool is to
> change the cpufreq governor to 'powersave' or 'userspace' (and then
> clock it at the lowest, manually).
>

Scratch that. It's probably an interrupt storm. 'perf top' shows
19,000 IRQs per second. And I recall that 500-1500 per second was
normal for this machine. Now the problem is figuring out where the
interrupt storm is coming from...

> I've tried 2.6.31.1 and Linus' current git tree
> (2.6.32-rc1-301-gf0a221e). My configs are attached.
>
> My system is a MacBookPro2,2. I'm running an x86_64 kernel.
>
> Any ideas of what could be going on? Am I missing something horribly obvious?
>
> - Steven
>
