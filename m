Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbZHNCzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbZHNCzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 22:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZHNCzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 22:55:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35876 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbZHNCzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 22:55:21 -0400
Message-ID: <4A84D1DB.6050304@zytor.com>
Date: Thu, 13 Aug 2009 19:54:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Wang, Shane" <shane.wang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [PATCH 1/1] intel_txt: to fix build errors of CONFIG_ACPI_SLEEP
References: <4A4ACA60.1000209@intel.com> <20090807072752.GA12119@elte.hu> <20090812145321.GA11347@elte.hu> <037F493892196B458CD3E193E8EBAD4F01EAB64402@pdsmsx502.ccr.corp.intel.com> <20090813064634.GA12143@elte.hu> <4A842C5B.7050100@zytor.com> <037F493892196B458CD3E193E8EBAD4F01EAB6464E@pdsmsx502.ccr.corp.intel.com>
In-Reply-To: <037F493892196B458CD3E193E8EBAD4F01EAB6464E@pdsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2009 07:06 PM, Wang, Shane wrote:
> I agree with hpa, considering TXT doesnot depends on acpi sleep.
> 
> However, for hpa's patch, set_mac_regions() is for S3 only. I am wondering whether we should enlarge the range of CONFIG_ACPI_SLEEP in set_mac_regions().
> Certainly, for code cleanness, this patch is fine since the assignment
> 
> 
> takes effect but tboot->mac_regions[] will never be used without S3.
> 

OK, that makes it easier.  We should just conditionalize the whole thing
then.  A lot cleaner than #ifdefing the individual assignments.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

