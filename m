Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbZGaRNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbZGaRNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 13:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZGaRNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 13:13:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42187 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZGaRNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 13:13:20 -0400
Message-ID: <4A7325E5.7040102@zytor.com>
Date: Fri, 31 Jul 2009 10:12:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Nicolas Palix <npalix@diku.dk>
CC: x86@kernel.org, Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix compilation error in amd.c when SMP is not set
References: <200907311640.25585.npalix@diku.dk>
In-Reply-To: <200907311640.25585.npalix@diku.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2009 07:40 AM, Nicolas Palix wrote:
> The function amd_fixup_dcm requires SMP to be set
> but it is called only when CONFIG_X86_HT is set.
> 
> It thus defined only if CONFIG_X86_HT is set.
> 
> Signed-off-by: Nicolas Palix <npalix@diku.dk>

I'm confused... I don't see this function anywhere in my trees, nor do I
see git revision e06fa7c that this was based on either in my trees or
the stable trees.  What is the base rev of this patch?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

