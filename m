Return-Path: <linux-kernel-owner+w=401wt.eu-S1030728AbXBOTUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030728AbXBOTUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:20:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030731AbXBOTUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:20:04 -0500
Received: from marvin.h-e-r-e-s-y.com ([87.106.62.5]:37083 "EHLO
	marvin.h-e-r-e-s-y.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030728AbXBOTUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:20:03 -0500
From: Andrew Walrond <andrew@walrond.org>
To: linux-kernel@vger.kernel.org
Subject: Modular kernel (2.6.20) and software raid auto detection
Date: Thu, 15 Feb 2007 19:19:59 +0000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702151920.00028.andrew@walrond.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


With my ide driver and the md stuff all built into the kernel, my software 
raid drives and associated /dev/md? devices are detected and created by the 
kernel.

With the md stuff built in but the ide driver modular and loaded later by 
udev, the drives are not detected.

So, I guessed that perhaps if I made the md stuff modular aswell and load it 
_after_ loading the ide driver, this might kickstart the auto-detect stuff. 
But it didn't :(

Is there a way to make auto-detection work without having the ide driver built 
in?

TIA

Andrew Walrond
