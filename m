Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbYCKRdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbYCKRdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYCKRdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:33:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:50645 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbYCKRdC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:33:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,481,1199692800"; 
   d="scan'208";a="217364717"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH, RFC] Create 'slot' sysfs attribute in/sys/devices/system/cpu/cpuN/topology/
Date: Tue, 11 Mar 2008 10:31:43 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECC8960D@orsmsx424.amr.corp.intel.com>
In-Reply-To: <20080310222735.GA22619@ldl.fc.hp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH, RFC] Create 'slot' sysfs attribute in/sys/devices/system/cpu/cpuN/topology/
Thread-Index: AciC/fH/EZSgZKXLRHiH2V78Fqzs0wAnovfA
References: <20080310222735.GA22619@ldl.fc.hp.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Alex Chiang" <achiang@hp.com>, <lenb@kernel.org>
Cc: <linux-ia64@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Mar 2008 17:31:46.0170 (UTC) FILETIME=[C7969DA0:01C8839D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A while back, I submitted a patch to expose the value of the _SUN
> method for CPUs. On ia64, the "physical id" field in
> /proc/cpuinfo isn't sufficient for some legacy HP ia64 platforms,
> as they do not have a modern SAL or PAL.

Do these legacy systems with ancient SAL/PAL actually support
processor hot plug?

Perhaps this next rant is beyond the scope of Linux architecture
and more on overall systems useabilty.  It is just asking for
trouble to print a message on the console telling the user to go
pull out the board in "slot 2".  Do the slot numbers count from
"0" or from "1"?  Are they numbered left-to-right or right-to-left?
What if the rack is non-standard so the system was rotated 90
degrees?  Now are they numbered top-to-bottom or bottom-to-top.

Best idea is to have a (blinking) (red) light on the board and
instruct the operator to pull out the board with the fail-light
(but even then a red-green colour blind operator will still mess
it up for you and pull the wrong board :-)

-Tony
