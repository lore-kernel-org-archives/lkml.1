Return-Path: <linux-kernel-owner+w=401wt.eu-S1161633AbYCSWcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161633AbYCSWcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763949AbYCSVFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:05:13 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:25579 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S936063AbYCSVFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:05:10 -0400
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2008 17:05:09 EDT
Date: Wed, 19 Mar 2008 14:55:44 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/3] EDAC Fix and new CHIPSET Support
Message-ID: <47e17dd0.uVih11U4QfOeGDXe%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Doug Thompson <dougthompson@xmission.com>

Fix to EDAC modules initialization to a more concise call instead
of a distributed implementation. Now each modules calls an inline
function to perform the initialization

Add Support for Intel 3100 chipset to the e752x_edac module

Add new parameter to the e752x_edac module for sysbus parity control

Signed-off-by:  Doug Thompson <dougthompson@xmission.com>
