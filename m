Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbYAIPZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbYAIPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 10:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYAIPZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 10:25:52 -0500
Received: from ns2.suse.de ([195.135.220.15]:39033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbYAIPZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 10:25:52 -0500
To: VUB Stefan Seidel <sseidel@vub.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Not all logical processors activated on Dual Core Xeon (== no Hyperthreading)
From: Andi Kleen <andi@firstfloor.org>
References: <47849240.3040305@vub.de>
Date: Wed, 09 Jan 2008 16:25:50 +0100
In-Reply-To: <47849240.3040305@vub.de> (VUB Stefan Seidel's message of "Wed\, 09 Jan 2008 10\:22\:08 +0100")
Message-ID: <p73odbvowap.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VUB Stefan Seidel <sseidel@vub.de> writes:

> I have the following system here: two dual-core Xeon 5130 on an Intel
> S5000V-SA motherboard. The kernel detects 4 CPUs, from what I learn
> through /proc/cpuinfo, these are the 4 cores (two per
> package). However, I think it should be 8 logical processors, because
> the Xeons should be able to do Hyperthreading (or

Core2 Duo based Xeons do not support Hyper Threading.

> ===========================
> but acpidump shows 8 CPUs in multiple locations:

That's likely because the BIOS supports Quad Core CPUs, but does
not disable the excessive objects if you only plug in Dual Core

-Andi
