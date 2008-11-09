Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbYKIU2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbYKIU2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbYKIU2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:28:36 -0500
Received: from eazy.amigager.de ([213.239.192.238]:33077 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbYKIU2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:28:35 -0500
Date: Sun, 9 Nov 2008 21:28:30 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Suspend regression in stable kernel 2.6.27.4 on Mac mini Core Duo
Message-ID: <20081109202830.GA7206@x61>
Mail-Followup-To: linux-kernel@vger.kernel.org, stable@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my Mac mini Core Duo doesn't wake up from suspend to RAM anymore with
2.6.27.4. It works with 2.6.27.3. I enabled pm_trace, but dmesg | grep
"hash matches" didn't show anything after resume. I tried 2.6.27.5,
which also failed to resume.

The system is i386, the hardware is basically Intel based: Core Duo
T2300 CPU, Intel graphics i945, ICH7, Marvell GbE (sky2), a SATA hard
disk, PATA DVD drive, a Firewire hard disk, and a lot of USB devices.

Does that ring any bells? Any hints what commit I should try to revert?

Regards,
Tino
