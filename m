Return-Path: <linux-kernel-owner+w=401wt.eu-S1762646AbZLPRdC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762646AbZLPRdC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:33:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762637AbZLPRc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:32:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57928 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762632AbZLPRc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:32:56 -0500
Message-ID: <4B2919BD.40001@zytor.com>
Date: Wed, 16 Dec 2009 09:32:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Borislav Petkov <borislav.petkov@amd.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 16 (amd64_edac)
References: <20091216183212.118c5e14.sfr@canb.auug.org.au> <20091216092424.5f87214c.randy.dunlap@oracle.com>
In-Reply-To: <20091216092424.5f87214c.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2009 09:24 AM, Randy Dunlap wrote:
> On Wed, 16 Dec 2009 18:32:12 +1100 Stephen Rothwell wrote:
> 
>> Hi all,
>>
>> My usual call for calm: please do not put stuff destined for 2.6.34 into
>> linux-next trees until after 2.6.33-rc1.
>>
>> Changes since 20091215:
> 
> 
> When CONFIG_SMP=n, CONFIG_X86_MSR=m:
> 
> ERROR: "msrs_free" [drivers/edac/amd64_edac_mod.ko] undefined!
> ERROR: "msrs_alloc" [drivers/edac/amd64_edac_mod.ko] undefined!
> 
> 
> Should EDAC_AMD64 also depend on SMP?
> 

That seems absurd... more likely msrs_free/msrs_alloc should not be
SMP-specific, or stubs need to be provided.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

