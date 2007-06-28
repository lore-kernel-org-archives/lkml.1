Return-Path: <linux-kernel-owner+w=401wt.eu-S1764928AbXF1Ra7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764928AbXF1Ra7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 13:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758536AbXF1Raw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 13:30:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:36164 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756936AbXF1Raw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 13:30:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,471,1175497200"; 
   d="scan'208";a="101115309"
Message-ID: <4683EFE2.3040409@linux.intel.com>
Date: Thu, 28 Jun 2007 10:29:06 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: New format Intel microcode...
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com>	 <1174610594.6598.3.camel@sli10-conroe.sh.intel.com>	 <6278d2220706261442u9b137c5xb6225b3f56605554@mail.gmail.com>	 <p731wfy5m74.fsf@bingen.suse.de>  <4683BD56.7070707@tmr.com> <1183039975.14676.12.camel@laptopd505.fenrus.org> <4683EF87.1050303@redhat.com>
In-Reply-To: <4683EF87.1050303@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 06/28/2007 10:12 AM, Arjan van de Ven wrote:
>> (while I work for Intel this is not an official Intel statement, but
>> there is so much FUD going around now that I feel I need to at least
>> point out a few things others "forget")
>>> Slashdot carried an article this morning saying that an error in Intel 
>>> microcode was being fixed.
>> don't just always believe everything you read on slashdot please
>>
>>>  However, it listed only Windows related sites 
>>> for the "fix" download. Is this the same TLB issue? And are these really 
>>> fixes for Windows to flush the TLB properly the way Linux does?
>> First of all, Linux has microcode updates as well. Some of the more
>> hypish news-bulletins just conveniently "forgot" about this. Basically
>> all distributions ship them, so users who use the distro update tools
>> get these automatically. And the update mentioned has been shipping for
>> a while (in version 1.17).
>>
> 
> Fedora 6 has version 1.13
> Fedora 7 also has 1.13

that's a fedora bug; we asked them to update it long ago in their 
bugzilla. Maybe they updated the datafile, maybe they didn't. Be 
careful with just looking at package version numbers, they don't per 
se corresponds with versions of the data file.


> RHEL 5 has 1.15

be careful, it has the 1.17 datafile in the updates afaik.
but RH doesn't update the package version number.


same may or may not be true for the others, but if you only look at 
package versions you don't get the datafile versions.
