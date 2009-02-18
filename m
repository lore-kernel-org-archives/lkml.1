Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbZBRSeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbZBRSeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbZBRSeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:34:22 -0500
Received: from kroah.org ([198.145.64.141]:58538 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754580AbZBRSeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:34:21 -0500
Date: Wed, 18 Feb 2009 10:32:07 -0800
From: Greg KH <greg@kroah.com>
To: david@lang.hm
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: enable MSI on 8132
Message-ID: <20090218183207.GA31520@kroah.com>
References: <499B724A.2040408@kernel.org> <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm> <499B774C.5010705@kernel.org> <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm> <499B9129.50104@kernel.org> <20090218122137.GJ16841@parisc-linux.org> <alpine.DEB.1.10.0902180426420.25606@asgard.lang.hm> <20090218100448.7f7c5b86.akpm@linux-foundation.org> <alpine.DEB.1.10.0902181014330.26625@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902181014330.26625@asgard.lang.hm>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 10:18:20AM -0800, david@lang.hm wrote:
> On Wed, 18 Feb 2009, Andrew Morton wrote:
>
>> Subject: Re: [PATCH] pci: enable MSI on 8132
>> On Wed, 18 Feb 2009 04:27:28 -0800 (PST) david@lang.hm wrote:
>>
>>> On Wed, 18 Feb 2009, Matthew Wilcox wrote:
>>>
>>>> On Tue, Feb 17, 2009 at 08:40:09PM -0800, Yinghai Lu wrote:
>>>>>
>>>>> Impact: workaround BIOS that doesn't enable that bit
>>>>>
>>>>> David reported that LSI sas doesn't work with MSI.
>>>>> it turns out that BIOS doesn't enable HT MSI
>>>>> 8132 does support HT MSI.
>>>>> add quirk to enable it
>>>>>
>>>>> Reported-by: David Lang <david@lang.hm>
>>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>>
>>>> Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
>>>>
>>>> Jesse, I think this should go into Linus' tree sooner rather than later.
>>>
>>> please forward to -stable as well. this is a regression since the card
>>> works with older kernels.
>>>
>>
>> Which kernel version introduced the regression?
>
> I'm not sure. I know that 2.6.24 Debian EThch-and-a-half worked, 2.6.27+ 
> failed. how critical is it to narrow down exactly where the problem crept 
> in?

If .27 fails, that's all we need to know, as only .27 and .28 are being
maintained by the -stable person :)

thanks,

greg k-h
