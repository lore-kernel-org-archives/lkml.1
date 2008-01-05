Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbYAENk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbYAENk6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 08:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbYAENkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 08:40:51 -0500
Received: from [212.12.190.157] ([212.12.190.157]:52800 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755050AbYAENkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 08:40:51 -0500
From: Al Boldi <a1426z@gawab.com>
Subject: Forcing modes in libata (was: SATA buffered read VERY slow)
Date: Sat, 5 Jan 2008 16:41:03 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200801051641.03927.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> hdparm supports identify to read modes on drives with libata. The one
> thing you cannot do is force modes right now.

I have some AOpen 52x/32x CD-RWriter, that advertises itself as DMA capable, 
but has a hard time sustaining such access.  The only way to make access to 
this drive safe is by reducing it to PIO-3 even on XP,  which makes libata 
somewhat unusable on this drive, especially for writing.

What's hindering the ability to force a mode in libata, as is possible with 
the normal ide-driver?


Thanks!

--
Al

