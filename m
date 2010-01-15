Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab0AOVSO (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757641Ab0AOVSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:18:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:57611 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab0AOVSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:18:13 -0500
Message-ID: <4B50DB3B.4080506@kernel.org>
Date: Fri, 15 Jan 2010 13:16:43 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 7/7] x86/pci: don't check mmconf again if it is from MSR
 with amd faml0h
References: <4B2BE063.4040704@kernel.org>	<4B2BE196.2000404@kernel.org> <20100115114205.247c5dd7@jbarnes-piketon>
In-Reply-To: <20100115114205.247c5dd7@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2010 11:42 AM, Jesse Barnes wrote:
> On Fri, 18 Dec 2009 12:09:58 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>>
>> for AMD Fam10h, it we read mmconf from MSR early, we should just
>> trust it because we check it and correct it already.
>>
>> so skip the reject check there.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> My previous question wasn't answered.  Either reject_broken should be a
> no-op on this platform, or it's getting things wrong and should be
> fixed.  Adding a whitelist here seems like the wrong thing to do...
> 

let me find other way, may update e820 directly.

YH
