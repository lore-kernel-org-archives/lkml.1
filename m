Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbZEZRjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbZEZRjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZEZRjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:39:35 -0400
Received: from mga10.intel.com ([192.55.52.92]:54146 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753734AbZEZRjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:39:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,253,1241420400"; 
   d="scan'208";a="693687145"
Message-Id: <20090526174012.423883376@linux.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 26 May 2009 19:40:12 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartmann <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 0/6] firmware: dynamic firmware id allocation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This 6 patches patch set allows for a removal of the firmware name length
restriction from the firmware class API.
Currently we're limited to 30 characters for firmware names because of a
statically allocated 30 bytes string in the firmware class code. We also want
to remove the FIRMWARE_NAME_MAX definition to prevent future drivers from
referencing it.

Patch #1 removes that restriction by dynamically allocating the firmware id.
Patches #2,3,4,5 remove all FIRMWARE_NAME_MAX references from the kernel code.
Patch #6 gets rid of the FIRMWARE_NAME_MAX definition, and should be applied
only once all previous patches from this patch set are applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
