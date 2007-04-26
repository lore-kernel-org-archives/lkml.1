Return-Path: <linux-kernel-owner+w=401wt.eu-S933175AbXDZG7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbXDZG7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbXDZG7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:59:12 -0400
Received: from imx12.toshiba.co.jp ([61.202.160.132]:52406 "EHLO
	imx12.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933168AbXDZG7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:59:11 -0400
X-Greylist: delayed 1833 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Apr 2007 02:59:11 EDT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Subject: RE: [PATCH 2/2]  Fixed typo Intel RNG driver for2.6.21-rc7-mm1
X-MimeOLE: Produced By Microsoft Exchange V6.5.7226.0
Date: Thu, 26 Apr 2007 15:56:20 +0900
Message-ID: <BF571719A4041A478005EF3F08EA6DF0043323E0@pcsmail03.pcs.pc.ome.toshiba.co.jp>
Thread-Topic: [PATCH 2/2]  Fixed typo Intel RNG driver for2.6.21-rc7-mm1
Thread-Index: AceHzR2wBTsSe4c3QnSxK6B7xIgcXgAACkaA
From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
To: "Jan Beulich" <jbeulich@novell.com>
Cc: <prarit@redhat.com>, "lkml" <linux-kernel@vger.kernel.org>,
       "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But why do you remove the printk()?

I think that FWH connected to LPC of ICHx are not only Intel products.
For example, sst... etc.
Does rng address differ in except Intel products? 
I think that this driver is targeting Intel FWH.
Therefore, printk() was removed.

# Do you think that a "FWH not detected" message is noisy?
--
Haruo
