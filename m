Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbZEZWt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbZEZWt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760142AbZEZWtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:49:05 -0400
Received: from mga10.intel.com ([192.55.52.92]:7632 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760052AbZEZWtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:49:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,254,1241420400"; 
   d="scan'208";a="693771771"
Message-Id: <20090526224930.145059254@linux.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 00:49:30 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: inux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartmann <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 0/7 v2] firmware: dynamic firmware id allocation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, hi Andrew,

This 6 patches patch set allows for a removal of the firmware name length
restriction from the firmware class API.
Currently we're limited to 30 characters for firmware names because of a
statically allocated 30 bytes string in the firmware class code. We also want
to remove the FIRMWARE_NAME_MAX definition to prevent future drivers from
referencing it.

Patch #1 removes that restriction by dynamically allocating the firmware id.
Patches #2,3,4,5,6 remove all FIRMWARE_NAME_MAX references from the kernel
code.
Patch #7 gets rid of the FIRMWARE_NAME_MAX definition, and should be applied
only once all previous patches from this patch set are applied.

Cheers,
Samuel.

v2: Included John Linville's patch for the libertas wireless driver.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
