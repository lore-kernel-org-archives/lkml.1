Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0BPMUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 07:20:31 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:58731 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab0BPMUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 07:20:30 -0500
X-Spam-ASN: 
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Extended error reporting to user space?
Date: Tue, 16 Feb 2010 15:20:26 +0300
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002161520.26700@zigzag.lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm developing a device driver that, in it's ioctl()s, accepts a complex 
data structure. Before doing it's operation, it performs large number of 
checks if data is valid. If one of those checks fail, driver 
returns -EINVAL.

Unfortunately this -EINVAL is not really useful. E.g. if a developer, 
sitting in his IDE and debugging his code, will see ioctl() 
returning -EINVAL, and will have hard times finding what exactly is wrong.

Before inventing driver-specific extended error reporting, I'd like to ask 
if there is anything more or less generic for this.
I believe situation when -Exxx is too weak interface for error reporting is 
common.

Nikita
