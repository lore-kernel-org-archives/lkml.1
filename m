Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbYE1RSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbYE1RSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 13:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYE1RSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 13:18:16 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:65084 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbYE1RSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 13:18:16 -0400
Message-ID: <483D93B2.9070809@nortel.com>
Date: Wed, 28 May 2008 11:17:38 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, wim@iguana.be, chandra.konduru@intel.com
Subject: iTCO watchdog timer broken for Intel 3100 chipset
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2008 17:17:43.0769 (UTC) FILETIME=[BDB2EC90:01C8C0E6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

We've got a board with the Intel 3100 chipset.  It shows a PCI id of 
2670, which matches PCI_DEVICE_ID_INTEL_ESB2_0 and so the iTCO_wdt.c 
driver happily initializes.  However, the documentation for the TCO wdt 
for this chipset doesn't match the implementation in the driver, so 
things get messed up.

I'm not sure why the PCI IDs match, but maybe there is something else 
that the iTCO_wdt driver should key off of to make sure it doesn't try 
to run invalid code?

On another note, it appears that Intel has driver code (written for 
2.6.18, under dual BSD/GPLv2) for the wdt for this chipset available at:

http://downloadcenter.intel.com/Detail_Desc.aspx?ProductID=2568&DwnldID=13653&lang=eng

Are there any plans to incorporate this into mainline?

Thanks,

Chris
