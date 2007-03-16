Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbXCPSh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbXCPSh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbXCPSh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:37:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:23922 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbXCPSh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:37:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,293,1170662400"; 
   d="scan'208"; a="213938417:sNHT21956543"
Message-ID: <45FAE3F3.1070807@intel.com>
Date: Fri, 16 Mar 2007 11:37:39 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.10 (X11/20070311)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21rc suspend to ram regression on Lenovo X60
References: <20070313040828.GA17893@redhat.com> <m1wt1ltveu.fsf@ebiederm.dsl.xmission.com> <20070316162117.GA3951@ucw.cz>
In-Reply-To: <20070316162117.GA3951@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2007 18:37:40.0519 (UTC) FILETIME=[2D70A370:01C767FA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> Seeing a couple of MSI changes in there, on a hunch I booted latest tree with
>>> pci=nomsi, and it resumed again.
>>>
>>> Any ideas how to further debug this?
>>> I'll try backing out individual changes from that merge tomorrow.
>> Thanks.  
>>
>> Of those msi patches you have identified I don't see anything really
>> obvious.  And you actually marked them as good in your bisect so
>> I don't expect it is core problem.
>>
>> We do have a known e1000 regression, with msi and suspend/resume.

still? I tested this against rc3 and it's mostly just fine. even with msi enabled.

>> So it is possible the nomsi avoided a driver problem.  Especially
>> as we have a number of driver changes on the on Linus's side of
>> that merge.
>>
>> I also know we have some known issues with pci_save_state and
>> pci_restore_state that require them to be paired for correct
>> operation.  For suspend and resume that is not generally a problem.
>>
>> I have fixes for the pci_save_state and pci_restore_state in the -mm
>> and gregkh tree's.  Since they also happen to fix the e1000 driver as
>> a side effect they are worth looking at, at least if you have an
>> e1000.

hey, please include me on those!

>> I don't have a clue which hardware the x60 has so I don't know which
>> drivers it would be using.
> 
> x60 indeed has e1000.

yup.

Auke
