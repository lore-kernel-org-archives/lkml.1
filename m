Return-Path: <linux-kernel-owner+w=401wt.eu-S1759929AbYBSSBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759929AbYBSSBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758058AbYBSSA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:00:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:53793 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758042AbYBSSAy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:00:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,377,1199692800"; 
   d="scan'208";a="258584575"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: iwl3945 not working properly.
Date: Tue, 19 Feb 2008 10:00:40 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003AF2CA1@orsmsx416.amr.corp.intel.com>
In-Reply-To: <20080218154713.GC3098@tuxdriver.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: iwl3945 not working properly.
Thread-Index: AchyS9tAssQoFNALRkep3jl1zNzP3AA1B1eQ
References: <20080218045425.GA7381@phoenix.nasreddine.info> <20080218154713.GC3098@tuxdriver.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
       "Wael Nasreddine" <mla@nasreddine.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>, "Zhu, Yi" <yi.zhu@intel.com>
X-OriginalArrivalTime: 19 Feb 2008 18:00:41.0624 (UTC) FILETIME=[57532180:01C87321]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 18, 2008 7:47 AM, John W. Linville  wrote:

> On Mon, Feb 18, 2008 at 05:54:25AM +0100, Wael Nasreddine wrote:
>> Hello,
>> 
>> I have a Toshiba Satellite A135-S4427 with and Intel 3945ABG card,
>> the driver is not working properly.
>> 
>> When I turn on my PC it works fine, but If I ever bring the interface
>> down, I no longer can associate it with any AP without rebooting,
>> even the one I was using, I tried rmmod/modprobe iwl3945, didn't do
>> anything, 
>> 
>> iwconfig shows that the wlan0 has the radio turned off, and
>> 
>> $ cat /sys/bus/pci/drivers/iwl3945/0000:04:00.0/rf_kill 1
>> 
>> Even If I echo 0 > /sys/bus/pci/drivers/iwl3945/0000:04:00.0/rf_kill
>> whenever I try to associate the interface with an AP it turns back to
>> 1, I tried both iwconfig and NetworkManager, same problem.
>> 
>> There's a button on my laptop for Radio SoftKill (fn+F8) but it's not
>> working, the soft kill is being enabled/disabled without my
>> interference. 
>> 
>> I tried it on kernel-2.6.24 and kernel-2.6.25-rc2 same result...
>> 
>> Any help is appreciated...
>> 
>> P.S: Please Cc to me, I am not subscribed to the mailing list.
> 
> This sounds similar to the bug here:
> 
> 	https://bugzilla.redhat.com/show_bug.cgi?id=432264
> 
> The OP in that bug reports that the problem continues even after
> reverting to older kernels that worked previously.
> 
> Hopefully part of the Intel crew will have some clue as to what is
> happending here? 

Wael,

Could you please help us debug this issue? Unfortunately none of the
bugs reported about this issue
(http://bughost.org/bugzilla/show_bug.cgi?id=1454 and
https://bugzilla.redhat.com/show_bug.cgi?id=432264) have any debugging
output. Please reopen bug
http://bughost.org/bugzilla/show_bug.cgi?id=1454 and add debugging
(loading module with debug=0x43fff) to your report to help us find out
what happens on your system when the driver loads as well as when you
change the rfkill settings.

Thank you very much

Reinette
