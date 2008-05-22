Return-Path: <linux-kernel-owner+w=401wt.eu-S1765829AbYEVVsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765829AbYEVVsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757934AbYEVVry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:47:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:28946 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757783AbYEVVrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:47:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,526,1204531200"; 
   d="scan'208";a="386304201"
From: "Sean Hefty" <sean.hefty@intel.com>
To: "'Greg KH'" <greg@kroah.com>
Cc: <rolandd@cisco.com>, <hal.rosenstock@gmail.com>,
       <general@lists.openfabrics.org>, <linux-kernel@vger.kernel.org>
References: <20080522203403.GA27263@kroah.com>
Subject: RE: question about drivers/infiniband/core/cm.c's kobject usage
Date: Thu, 22 May 2008 14:47:51 -0700
Message-ID: <000501c8bc55$7c2dd680$ec248686@amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20080522203403.GA27263@kroah.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: Aci8Ue/yhPG9m7JwTtqTh5OeQMpZqQAAOTOw
X-OriginalArrivalTime: 22 May 2008 21:47:52.0178 (UTC) FILETIME=[7C2F5D20:01C8BC55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>So I was curious, was this done on purpose?  If so, why?  If not, any
>objection to me switching it over to be using struct device properly?

It's entirely possible I have this wrong, but the intent is to export some
infiniband communication management message counters and relate them to the
corresponding ib_device/port.  For example:

/sys/class/infiniband_cm/<device name>/<port number>/<counter group>/<counter>

(E.g. /sys/class/infiniband_cm/mthca0/1/cm_tx_msgs/req)

If there's a better way to handle this, I have no objection to changing it.

- Sean

