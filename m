Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZIIR0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZIIR0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZIIR0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:26:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40921 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbZIIR0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:26:11 -0400
Message-ID: <4AA7DA4E.8010504@zytor.com>
Date: Wed, 09 Sep 2009 09:39:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Print amd virtualization features in /proc/cpuinfo
References: <1249996732-13794-1-git-send-email-joerg.roedel@amd.com> <20090909161643.GB15711@amd.com>
In-Reply-To: <20090909161643.GB15711@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 09:16 AM, Joerg Roedel wrote:
> Hi Ingo,
> 
> do you have any objections against this patch? Please let me know so I
> can fix them.
> 
> Thanks,
> 
> 	Joerg

These features should be table-driven like the ones already in
scattered_cpuid_features() instead of open-coded.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

