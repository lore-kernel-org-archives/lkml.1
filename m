Return-Path: <linux-kernel-owner+w=401wt.eu-S1762531AbYF0SVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762531AbYF0SVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758128AbYF0SUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:20:51 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11657 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757398AbYF0SUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:20:49 -0400
Date: Fri, 27 Jun 2008 12:12:48 -0600
From: dougthompson@xmission.com
To: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 0/13] EDAC i5100 New Intel Driver and some fixes
Message-ID: <48652da0.2tdZ8SYADD6dcI5J%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Doug Thompson <dougthompson@xmission.com>

Applied to 2.6.26-rc5-mm3

This set of patches to edac consists of the following:

1) New edac driver for the Intel 5100 MCH chipset. Also are some fixes for the same

2) mpc85xx PCI ofsev patch to properly configure the device

3) EDAC core fixes consisting of kobject correct use as dynamic and not as static values

4) Add a newline to DIMM label sysfs attributes

5) e752x_edac is too loud for nonmemory errors. Added a boolean parameter to allow
enabling of nonmemory error output. Default off

6) Add some fixes for mv64x60

Signed-off-by:  Doug Thompson <dougthompson@xmission.com>
