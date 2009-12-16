Return-Path: <linux-kernel-owner+w=401wt.eu-S1759270AbZLPWr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270AbZLPWr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759254AbZLPWrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:47:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:47754 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZLPWru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:47:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,408,1257148800"; 
   d="scan'208";a="579656747"
Message-ID: <4B296394.9010709@intel.com>
Date: Wed, 16 Dec 2009 15:47:48 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Kim Phillips <Kim.Phillips@freescale.com>,
       Vishnu Suresh <Vishnu@freescale.com>,
       "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
       "B04825@freescale.com" <B04825@freescale.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
       Dipen Dudhat <Dipen.Dudhat@freescale.com>,
       Maneesh Gupta <Maneesh.Gupta@freescale.com>,
       "R58472@freescale.com" <R58472@freescale.com>
Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR offload
References: <1260977698-4076-1-git-send-email-Vishnu@freescale.com> <20091216164144.daff5468.kim.phillips@freescale.com> <2868C8CF-584B-4FA7-9C3B-2FACEF77527E@kernel.crashing.org>
In-Reply-To: <2868C8CF-584B-4FA7-9C3B-2FACEF77527E@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
>>> Changes with respect to v1 as per comments received
>>> o. Rebased to linux-next as of 20091216
>>> o. The selection is based exclusive of fsldma
>>> o. Intoduced a new Kernel Configuration variable
>>>   *. This enables selecting the Cryptographic functionality
>>>      of Talitos along with fsldma.
>>>   *. Disables the XOR parity calculation offload, if fsldma enabled
>>>      either as kernel in-built or as a module
>>>   *. Once the inter-operability with fsldma is resolved, this option
>>>      can be removed
>> wait, why can't the interoperability bug be fixed in the first place?
> 
> I agree w/Kim.  We need to better understand what the bug is and how to reproduce it so we can get to the root cause.
> 
> Paper taping over it by disabling fsldma is not the right solution.

Hopefully this prompts fsldma authors to get involved because the 
interoperability issue has been out there without comment*, just 
band-aids, since October.

--
Dan

* well one comment from Ira saying the interrupt functionality worked 
for him.
