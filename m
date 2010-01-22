Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678Ab0AVB4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab0AVB4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619Ab0AVB4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:56:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:52007 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268Ab0AVB43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:56:29 -0500
Message-ID: <4B59059A.7090206@kernel.org>
Date: Thu, 21 Jan 2010 17:55:38 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/7] x86/pci: use resource_size_t in update_res -v2
References: <4B2BE063.4040704@kernel.org>	<4B2BE181.5090406@kernel.org>	<20100115114956.6207cfa4@jbarnes-piketon>	<4B50DC35.4080502@kernel.org> <20100115133932.5d622fdc@jbarnes-piketon>
In-Reply-To: <20100115133932.5d622fdc@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2010 01:39 PM, Jesse Barnes wrote:
> On Fri, 15 Jan 2010 13:20:53 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> On 01/15/2010 11:49 AM, Jesse Barnes wrote:
>>> On Fri, 18 Dec 2009 12:09:37 -0800
>>> Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>>>
>>>>
>>>> prepare to enable 32bit intel and amd bus
>>>>
>>>> v2: change __init to __devinit
>>>>
>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>> ---
>>>
>>> Applied 2-3 to my linux-next branch, thanks.  (1 was already
>>> applied to fix Jens' problem over the holidays, thanks hpa).
>>>
>>
>> will find out good apply sequence....
> 
> Pushing the ones for 32 bit bus driver support through -tip is fine
> with me, you can add my Acked-by.

please drop 2 and 3 from pci/linux-next tree. we need to make them go through tip/x86 tree with range related seperating code.

http://git.kernel.org/?p=linux/kernel/git/jbarnes/pci-2.6.git;a=commitdiff;h=f84fe8aef6e4b23ab58175a15dd12c197c993f81
http://git.kernel.org/?p=linux/kernel/git/jbarnes/pci-2.6.git;a=commitdiff;h=693f084f82a38fc1b01e3b05664a6fe014a3488a


Thanks

Yinghai
