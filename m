Return-Path: <linux-kernel-owner+w=401wt.eu-S1762713AbYBSWbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762713AbYBSWbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbYBSWaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:30:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:48432 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304AbYBSWav convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:30:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,378,1199692800"; 
   d="scan'208";a="521241141"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Recent driver in linux kernel 2.6.25-rc2
Date: Tue, 19 Feb 2008 14:28:58 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003AF3199@orsmsx416.amr.corp.intel.com>
In-Reply-To: <20080219153910.GA4303@ics.muni.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Recent driver in linux kernel 2.6.25-rc2
Thread-Index: AchzEMUKJ2mpfzhPRu2kC20jmoKntgANdttQ
References: <20080219153910.GA4303@ics.muni.cz>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Lukas Hejtmanek" <xhejtman@ics.muni.cz>,
       <ipw3945-devel@lists.sourceforge.net>
Cc: <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>
X-OriginalArrivalTime: 19 Feb 2008 22:28:58.0269 (UTC) FILETIME=[D1AC3CD0:01C87346]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On , Lukas Hejtmanek  wrote:

> as of pre 2.6.25 kernels, kismet monitoring tool does not work with
> the message: # kismet
> Launching kismet_server: //usr/bin/kismet_server
> Suid priv-dropping disabled.  This may not be secure.
> No specific sources given to be enabled, all will be enabled.
> Non-RFMon VAPs will be destroyed on multi-vap interfaces (ie,
> madwifi-ng) Enabling channel hopping.
> Enabling channel splitting.
> Source 0 (iwl4965): Enabling monitor mode for iwl4965 source
> interface wlan0 channel 6...
> FATAL: Failed to set channel 6 5:Input/output error

Please load the driver with debugging enabled (debug=0x43fff) and send
us the log capturing during this kismet startup.

Thanks

Reinette
