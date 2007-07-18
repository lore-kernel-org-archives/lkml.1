Return-Path: <linux-kernel-owner+w=401wt.eu-S937234AbXGQXzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937234AbXGQXzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757233AbXGQXze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:55:34 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11534 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754583AbXGQXzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:55:33 -0400
Date: Tue, 17 Jul 2007 18:02:14 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, greg@kroah.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/6] drivers edac tidying-fix-deadlock-sysfs-docs
Message-ID: <469d5886.CpTkivQRuQDgerlV%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Doug Thompson <dougthompson@xmission.com>

This EDAC patch set was applied against: 2.6.22-rc6-mm1

6 Patches in this set

1) tidying EXPORT_SYMBOL to EXPORT_SYMBOL_GPL modes, plus blank line removal

2) workq reset deadlock fix. Moved teardown outside of critical section

3) new i82975x driver for ASUS motherboards submitted.

4) EDAC MAINTAINERs updated for new entries, etc

5) found an old internal EDAC structure that was incorrect in the processing
   of block leaf attributes. Amazing it hadn't faulted, just gave bad data.
   Removed that, and replaced with the correct structure from edac_core.h
   Then refactored code to utilize this structure.
   Error occurred in leaf control/attribute presentation to user

6) Enhanced the EDAC documentation to reflect updated status of EDAC
   including the 'edac_device' class of device, which supports
   non-memory type of ECC hardware detectors.


Signed-off-by:  Doug Thompson <dougthompson@xmission.com>

