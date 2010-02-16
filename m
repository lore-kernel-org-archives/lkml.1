Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640Ab0BPXsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 18:48:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44814 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933073Ab0BPXsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 18:48:41 -0500
Message-ID: <4B7B2E3B.9060903@zytor.com>
Date: Tue, 16 Feb 2010 15:46:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 27/35] core: move early_res
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>	<1265793639-15071-28-git-send-email-yinghai@kernel.org> <20100215011615.e3d35121.sfr@canb.auug.org.au> <4B786110.9020806@kernel.org>
In-Reply-To: <4B786110.9020806@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2010 12:46 PM, Yinghai Lu wrote:
> 
> please check
> 
> Subject: [PATCH -v2] x86: fix cross-arch compiling
> 
> Ingo found:
> lots of cross-arch build failures in latest -tip:
> 
>  
> +u64 __init __weak get_max_mapped(void)
> +{
> +	panic("should have get_max_mapped defined with arch");
> +
> +	return -1ULL;
> +}
> +

All this does would seem is it would change a build failure into a
runtime panic.  I really fail to see how this is an improvement...

	-hpa
