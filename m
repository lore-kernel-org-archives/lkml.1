Return-Path: <linux-kernel-owner+w=401wt.eu-S1758958AbXH1RVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbXH1RVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 13:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbXH1RUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 13:20:53 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:19261 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751345AbXH1RUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 13:20:52 -0400
Date: Tue, 28 Aug 2007 11:21:19 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/2] drivers edac fix return code and debug output level
Message-ID: <46d4598f.BxSBsZgRMor34ZMQ%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Doug Thompson <dougthompson@xmission.com>

This EDAC patch set was applied against: 2.6.23-rc3

Two fix patches:

1) When EDAC Debug is turned on, the debug statements
issue printk level of EMERG. This was corrected to issue
a level of DEBUG

2) e752x driver, instead of returning ENOMEM if a device
was not present, the correct value of ENODEV is returned

Signed-off-by:  Doug Thompson <dougthompson@xmission.com>
