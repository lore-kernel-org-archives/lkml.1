Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbZHTQGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbZHTQGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 12:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZHTQGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 12:06:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58789 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZHTQGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 12:06:44 -0400
Message-ID: <4A8D743D.6000504@zytor.com>
Date: Thu, 20 Aug 2009 09:05:17 -0700
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
Subject: Re: [RFC v6][PATCH 2/4] intel_txt: Intel(R) TXT reboot/halt	shutdown
 support
References: <4A4ACA66.2000706@intel.com> <20090817154055.GA12985@elte.hu> <20090817155348.GA2254@elte.hu> <037F493892196B458CD3E193E8EBAD4F01EC3AB3B2@pdsmsx502.ccr.corp.intel.com>
In-Reply-To: <037F493892196B458CD3E193E8EBAD4F01EC3AB3B2@pdsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2009 02:33 AM, Wang, Shane wrote:
> Hi Ingo & hpa,
> 
> I have made some change on the previous tboot patch to fix the build errors.
> Please comment.
> 
> Thanks.
> Shane
> 

This code addresses the build errors, but not in the right manner.

We should not have to have tboot-specific #ifdefs in tons and tons of
arch-generic files; we need to figure out how to move them into code
flow already in arch-specific code, or we need to very carefully figure
out what additional arch-specific operations are needed at a higher level.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

