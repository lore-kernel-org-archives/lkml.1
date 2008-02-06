Return-Path: <linux-kernel-owner+w=401wt.eu-S1764454AbYBFXOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764454AbYBFXOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763975AbYBFXJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:09:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:44177 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760358AbYBFXJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:09:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,314,1199692800"; 
   d="scan'208";a="336071506"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: ipw3945: not only it periodically dies, it also BUG()s
Date: Wed, 6 Feb 2008 15:08:57 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003983522@orsmsx416.amr.corp.intel.com>
In-Reply-To: <20080206210026.GA32641@elf.ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ipw3945: not only it periodically dies, it also BUG()s
Thread-Index: AchpA6GyVSSBv8TLQhGq6I6Yh6OVZQAEOtfQ
References: <20080205214441.GA1518@elf.ucw.cz> <D936D925018D154694D8A362EEB0892003982BB1@orsmsx416.amr.corp.intel.com> <20080206143218.GA16188@elf.ucw.cz> <D936D925018D154694D8A362EEB0892003982E4C@orsmsx416.amr.corp.intel.com> <20080206210026.GA32641@elf.ucw.cz>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: <ipw3945-devel@lists.sourceforge.net>, <linux-wireless@vger.kernel.org>,
       "Zhu, Yi" <yi.zhu@intel.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 06 Feb 2008 23:08:58.0781 (UTC) FILETIME=[411E8CD0:01C86915]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 06, 2008 1:00 PM, Pavel Machek  wrote:

>    * dmesg output at debug level 0x43fff
>      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 		it would be nice to specify how to do this. It is
> insmod parameter, right?

correct. you can do this as follows:
$ insmod iwl3945 debug=0x43fff
or
$ modprobe iwl3945 debug=0x43fff

>    * Before reporting any firmware errors, please be sure to read Ben
> Cahill's mailing list post on how to most effectively report such
>    bugs.
>
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> unfortunately the link here does not work. 

We'll try to dig out the instructions from another location and update
that link. Thanks for letting us know.

> 
> BTW, why not use kernel.org bugzilla? Having to create another
> account is nasty... 

Users can report iwlwifi bugs in many locations ... their OSV's bug
tracker (which could end up being many) as well as the kernel.org
bugzilla. We focus on bugs in the bughost.org system.

Reinette
