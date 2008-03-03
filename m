Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbYCCUvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbYCCUvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750817AbYCCUvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:51:00 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:59129
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbYCCUu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:50:59 -0500
Message-ID: <47CC6422.5030806@qumranet.com>
Date: Mon, 03 Mar 2008 22:48:34 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: replace remaining __FUNCTION__ occurances
References: <1204573043.3266.50.camel@brick>
In-Reply-To: <1204573043.3266.50.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> __FUNCTION__ is gcc-specific, use __func__
>
>   

Which is shorter too.

>  arch/x86/kvm/lapic.c          |    8 ++++----
>  arch/x86/kvm/mmu.c            |   34 +++++++++++++++++-----------------
>  arch/x86/kvm/paging_tmpl.h    |   14 +++++++-------
>  arch/x86/kvm/svm.c            |   12 ++++++------
>  arch/x86/kvm/vmx.c            |    6 +++---
>  arch/x86/kvm/x86.c            |   10 +++++-----
>   

Please send the kvm parts against kvm.git instead of mainline to avoid 
needless merges.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

