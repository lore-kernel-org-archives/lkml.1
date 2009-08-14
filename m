Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbZHNIxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbZHNIxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 04:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbZHNIxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 04:53:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:46580 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbZHNIxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 04:53:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,379,1246863600"; 
   d="scan'208";a="483528079"
From: "Wang, Shane" <shane.wang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Date: Fri, 14 Aug 2009 16:52:36 +0800
Subject: RE: [PATCH 1/1] intel_txt: to fix build errors of CONFIG_ACPI_SLEEP
Thread-Topic: [PATCH 1/1] intel_txt: to fix build errors of CONFIG_ACPI_SLEEP
Thread-Index: Acoci/7HgMwoUPCLQz+cOYXb9Tu2MQAMI2Aw
Message-ID: <037F493892196B458CD3E193E8EBAD4F01EAB6484A@pdsmsx502.ccr.corp.intel.com>
References: <4A4ACA60.1000209@intel.com> <20090807072752.GA12119@elte.hu>
 <20090812145321.GA11347@elte.hu>
 <037F493892196B458CD3E193E8EBAD4F01EAB64402@pdsmsx502.ccr.corp.intel.com>
 <20090813064634.GA12143@elte.hu> <4A842C5B.7050100@zytor.com>
 <037F493892196B458CD3E193E8EBAD4F01EAB6464E@pdsmsx502.ccr.corp.intel.com>
 <4A84D432.2040704@zytor.com>
In-Reply-To: <4A84D432.2040704@zytor.com>
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

H. Peter Anvin wrote:
> On 08/13/2009 07:06 PM, Wang, Shane wrote:
>> I agree with hpa, considering TXT doesnot depends on acpi sleep.
>> 
>> takes effect but tboot->mac_regions[] will never be used without S3.
>> 
> 
> Given that, I would create a function called tboot_setup_suspend() or
> something like that and localize the setting of mac_regions as well as
> s3_resume_vector there.
> 
> Since it looks like s3_resume_vector is simply set up in tboot_sleep()
> before we'd call tboot_shutdown(), we can presumably simply do it all
> in tboot_shutdown().
> 
> Ingo, Shane: how does the attached patch look?
> 
> 	-hpa

ACK.

Thanks.
Shane