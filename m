Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472Ab0ADVOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0ADVOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397Ab0ADVOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:14:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:36511 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390Ab0ADVOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:14:51 -0500
Message-ID: <4B4259FB.1000804@kernel.org>
Date: Mon, 04 Jan 2010 13:13:31 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org,
       "Yinghai Lu <yingai@kernrel.org>"@hera.kernel.org
Subject: Re: [PATCH -v2 0/25] x86: use early_res instead of bootmem before
 slab
References: <1261525263-13763-1-git-send-email-yinghai@kernel.org> <alpine.DEB.2.00.1001041147240.7191@router.home>
In-Reply-To: <alpine.DEB.2.00.1001041147240.7191@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 09:48 AM, Christoph Lameter wrote:
> On Tue, 22 Dec 2009, Yinghai Lu wrote:
> 
>> From: "Yinghai Lu <yingai@kernrel.org>"
>>
>> please check the patches regarding with early_res and bootmem
>>
>> and at last it will make use early_res instead of bootmem with x86 64bits
>>
>> the first two are needed for some amd_bus.c/intel_bus.c cleaning up patches too.
>> so put other x86/pci related into this series
>> hope that is ok to Jesse.
>>
>> -v2: allocate vmemmap on one node together, and also seperate early_res
> 
> The point of this patchset is what?
> 
> Avoid use of bootmem altogether by x86 bootstrap? If so why?
> 

http://lkml.indiana.edu/hypermail/linux/kernel/0910.3/01432.html

YH
