Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbYLRWCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbYLRWCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYLRWCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:02:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:7862 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbYLRWCg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:02:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,245,1228118400"; 
   d="scan'208";a="372101894"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Date: Thu, 18 Dec 2008 14:03:18 -0800
Subject: RE: [patch 7/7] x86 PAT: update documentation to cover pgprot and
 remap_pfn related changes - v3
Thread-Topic: [patch 7/7] x86 PAT: update documentation to cover pgprot and
 remap_pfn related changes - v3
Thread-Index: AclhWxfCPX1mE3nfTWqWSef3BrU4PwAAQTBg
Message-ID: <7E82351C108FA840AB1866AC776AEC4643503FF0@orsmsx505.amr.corp.intel.com>
References: <20081218194126.963894000@intel.com>
 <20081218194617.987565000@intel.com> <494ABCF8.8050802@oracle.com>
 <20081218214940.GA31088@linux-os.sc.intel.com> <494AC64A.5000206@oracle.com>
In-Reply-To: <494AC64A.5000206@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Randy Dunlap [mailto:randy.dunlap@oracle.com] 
>Sent: Thursday, December 18, 2008 1:53 PM
>To: Pallipadi, Venkatesh
>Cc: mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com; 
>akpm@linux-foundation.org; npiggin@suse.de; hugh@veritas.com; 
>arjan@infradead.org; jbarnes@virtuousgeek.org; 
>rdreier@cisco.com; jeremy@goop.org; 
>linux-kernel@vger.kernel.org; Siddha, Suresh B
>Subject: Re: [patch 7/7] x86 PAT: update documentation to 
>cover pgprot and remap_pfn related changes - v3
>
>Pallipadi, Venkatesh wrote:
>> On Thu, Dec 18, 2008 at 01:13:28PM -0800, Randy Dunlap wrote:
>>> venkatesh.pallipadi@intel.com wrote:
>>>
>>> +Advanced APIs for drivers
>>> +-------------------------
>>> +A. Exporting pages to user with remap_pfn_range, 
>io_remap_pfn_range,
>>>
>>>                     to users
>>> or                  to userspace
>>>
>>> +vm_insert_pfn
>>> +
>>> +Drivers wanting to export some pages to userspace, do it 
>by using mmap
>>>
>>> Drop comma.
>>>
>>> +interface and a combination of
>>> +1) pgprot_noncached()
>>> +2) io_remap_pfn_range() or remap_pfn_range() or vm_insert_pfn()
>>> +
>>> +With pat support, a new API pgprot_writecombine is being 
>added. So, driver can
>>>
>>> s/pat/PAT/
>>> s/driver/drivers/ or s/driver/a driver/
>>>
>>> +continue to use the above sequence, with either 
>pgprot_noncached() or
>>> +pgprot_writecombine() in step 1, followed by step 2.
>>> +
>>> +In addition, step 2 internally tracks the region as UC or 
>WC in memtype
>>> +list in order to ensure no conflicting mapping.
>>> +
>>> +Note that this set of APIs only work with IO (non RAM) 
>regions. If driver
>>>
>>>                                  works with IO (non-RAM) 
>regions. If a driver
>>>
>>> +wants to export RAM region, it has to do set_memory_uc() 
>or set_memory_wc()
>>>
>>>           export a RAM region,
>>>
>>> +as step 0 above and also track the usage of those pages 
>and use set_memory_wb()
>>> +before the page is freed to free pool.
>>>
>>>
>>
>> refreshed patch below
>
>Some of them were changed, others not changed, with no explanation...
>More changes below:

Sorry. Not sure how I missed it :( (note to self - do not send
patches soon after lunch). Will promise to do all the changes
as an incremental patch along with other comments.

Thanks,
Venki

