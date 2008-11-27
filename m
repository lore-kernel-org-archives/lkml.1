Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbYK0VUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbYK0VUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 16:20:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbYK0VTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 16:19:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43333 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbYK0VTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 16:19:35 -0500
Message-ID: <492F0EB7.70308@zytor.com>
Date: Thu, 27 Nov 2008 13:18:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>, x86@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: oops/warning report for the week of November 26, 2008
References: <492DD792.6080302@linux.intel.com>	<20081127115236.GE29013@elte.hu>	<492EE087.80708@linux.intel.com>	<20081127201836.GA16869@elte.hu> <20081127122800.45fc0b1a@linux.intel.com>
In-Reply-To: <20081127122800.45fc0b1a@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> +	if (!cpu_has_mtrr)
> +		return 0;
>  	if (!is_cpu(INTEL) || disable_mtrr_trim)
>  		return 0;
>  	rdmsr(MTRRdefType_MSR, def, dummy);

cpu_has_mtrr there should presumably replace is_cpu(INTEL).  I'm not 
sure if this can be replaced by use_intel(); in particular use_intel() 
relies on mtrr_if having been initialized.

Looking...

	-hpa (out of town for Thanksgiving)
