Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbYG2ChD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbYG2ChD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYG2Cgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:36:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:22333 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbYG2Cgw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:36:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,269,1215414000"; 
   d="scan'208";a="423076781"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 3/3] PCI: Add pci_read_base() API
Date: Tue, 29 Jul 2008 10:36:49 +0800
Message-ID: <7A25B56E4BE99C4283EB931CD1A40E1101587039@pdsmsx414.ccr.corp.intel.com>
In-Reply-To: <20080729014931.GB28989@parisc-linux.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/3] PCI: Add pci_read_base() API
Thread-Index: AcjxHV2jjoZ2V1bgRTeoOVjuOZ1DNwABn2yQ
References: <1217266741-26519-1-git-send-email-matthew@wil.cx> <1217266741-26519-4-git-send-email-matthew@wil.cx> <7A25B56E4BE99C4283EB931CD1A40E1101586F18@pdsmsx414.ccr.corp.intel.com> <20080729014931.GB28989@parisc-linux.org>
From: "Zhao, Yu" <yu.zhao@intel.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Cc: <linux-kernel@vger.kernel.org>, <eric@anholt.net>,
       "Matthew Wilcox" <willy@linux.intel.com>, <jbarnes@virtuousgeek.org>
X-OriginalArrivalTime: 29 Jul 2008 02:36:51.0231 (UTC) FILETIME=[F4BE22F0:01C8F123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 29, 2008 9:50 AM, Matthew Wilcox <mailto:matthew@wil.cx> wrote:

> On Tue, Jul 29, 2008 at 09:22:03AM +0800, Zhao, Yu wrote:
>> Greetings,
>> 
>> It would be nice if people can have an enhanced
> pci_update_resource to update non-standard BARs probed by
> pci_read_base. 
> 
> Yes, that would be a natural addition to the API.  However, we don't
> tend to add APIs until we have a use case for them.  Do you have
> anything in the pipeline that could use this feature?  I'm quite happy
> to write the code for you if you do.

There is a new PCIe extended capability SR-IOV, which defines 6 additional BARs encapsulated inside the capability. I'm writing code to support it, and will be using your APIs to probe and update these non-standard BARs.

The SR-IOV specification can be found at:
http://www.pcisig.com/members/downloads/specifications/iov/sr-iov1.0_11Sep07.pdf

Thanks.

> 
> --
> Intel are signing my paycheques ... these opinions are still mine
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."

