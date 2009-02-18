Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZBRM21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZBRM21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZBRM2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:28:15 -0500
Received: from mail.lang.hm ([64.81.33.126]:45933 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbZBRM2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:28:14 -0500
Date: Wed, 18 Feb 2009 04:27:28 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Wilcox <matthew@wil.cx>
cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: enable MSI on 8132
In-Reply-To: <20090218122137.GJ16841@parisc-linux.org>
Message-ID: <alpine.DEB.1.10.0902180426420.25606@asgard.lang.hm>
References: <499B46B2.5040601@kernel.org> <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm> <499B6BF7.9090300@kernel.org> <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm> <499B724A.2040408@kernel.org> <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm>
 <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm> <499B774C.5010705@kernel.org> <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm> <499B9129.50104@kernel.org> <20090218122137.GJ16841@parisc-linux.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009, Matthew Wilcox wrote:

> On Tue, Feb 17, 2009 at 08:40:09PM -0800, Yinghai Lu wrote:
>>
>> Impact: workaround BIOS that doesn't enable that bit
>>
>> David reported that LSI sas doesn't work with MSI.
>> it turns out that BIOS doesn't enable HT MSI
>> 8132 does support HT MSI.
>> add quirk to enable it
>>
>> Reported-by: David Lang <david@lang.hm>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
>
> Jesse, I think this should go into Linus' tree sooner rather than later.

please forward to -stable as well. this is a regression since the card 
works with older kernels.

David Lang
