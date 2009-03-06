Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbZCFJIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbZCFJIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbZCFJIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:08:20 -0500
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:48466 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713AbZCFJIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:08:18 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-01.arcor-online.net 47DBC332D4B
From: Prakash Punnoor <prakash@punnoor.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: don't enable too many HT MSI mapping
Date: Fri, 6 Mar 2009 10:10:35 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7; KDE/4.2.1; x86_64; ; )
Cc: Matthew Wilcox <matthew@wil.cx>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <20090306011036.GB829@parisc-linux.org> <49B0A371.4040208@kernel.org>
In-Reply-To: <49B0A371.4040208@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903061010.36608.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Freitag 06 März 2009 05:15:45 Yinghai Lu wrote:
> please check v4:

v4 also works for me - nice. In case v4 doesn't get merged but instead the 
minimal version, this should be added also:

[patch, trivial] Fix typo in message while disabling HT MSI mapping

Signed-off-by: Prakash Punnoor <prakash@punnoor.de>

--- drivers/pci/quirks.c.old	2009-03-06 00:34:40.996532222 +0100
+++ drivers/pci/quirks.c	2009-03-06 10:06:19.251037862 +0100
@@ -2097,7 +2097,7 @@
 
 		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS,
 					 &flags) == 0) {
-			dev_info(&dev->dev, "Enabling HT MSI Mapping\n");
+			dev_info(&dev->dev, "Disabling HT MSI Mapping\n");
 
 			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
 					      flags & ~HT_MSI_FLAGS_ENABLE);
