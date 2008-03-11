Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbYCKAgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbYCKAgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 20:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbYCKAg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 20:36:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:26188 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbYCKAg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 20:36:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,477,1199692800"; 
   d="scan'208";a="531750508"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Recent driver in linux kernel 2.6.25-rc2
Date: Mon, 10 Mar 2008 17:35:32 -0700
Message-ID: <D936D925018D154694D8A362EEB0892003DB2DC5@orsmsx416.amr.corp.intel.com>
In-Reply-To: <20080219224418.GA20926@ics.muni.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Recent driver in linux kernel 2.6.25-rc2
thread-index: AchzSSMlFIJkrq8eTPCKKLA+3FMGhwPxiT9w
References: <20080219153910.GA4303@ics.muni.cz> <D936D925018D154694D8A362EEB0892003AF3199@orsmsx416.amr.corp.intel.com> <20080219224418.GA20926@ics.muni.cz>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Lukas Hejtmanek" <xhejtman@ics.muni.cz>
Cc: <ipw3945-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       <linux-wireless@vger.kernel.org>
X-OriginalArrivalTime: 11 Mar 2008 00:35:31.0340 (UTC) FILETIME=[CFC1ECC0:01C8830F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 19, 2008 2:44 PM, Lukas Hejtmanek  wrote:

> On Tue, Feb 19, 2008 at 02:28:58PM -0800, Chatre, Reinette wrote:
>>> as of pre 2.6.25 kernels, kismet monitoring tool does not work with
>>> the message: # kismet Launching kismet_server:
>>> //usr/bin/kismet_server 
>>> Suid priv-dropping disabled.  This may not be secure.
>>> No specific sources given to be enabled, all will be enabled.
>>> Non-RFMon VAPs will be destroyed on multi-vap interfaces (ie,
>>> madwifi-ng) Enabling channel hopping.
>>> Enabling channel splitting.
>>> Source 0 (iwl4965): Enabling monitor mode for iwl4965 source
>>> interface wlan0 channel 6... FATAL: Failed to set channel 6
>>> 5:Input/output error 
>> 
>> Please load the driver with debugging enabled (debug=0x43fff) and
>> send us the log capturing during this kismet startup.
> 
> the log is attached.

sorry for the delay - please do submit a bug at bughost.org to enable us
to track this problem.

The error you get is strange - the reason why the channel could not be
set was because the device is not considered to be ready. Yet, from your
debug log all the required steps appear to have completed successfully.
Could you please add a print to the function
iwl4965-base.c:iwl4965_is_ready to see what the value of priv->status
is?

Thanks

Reinette
