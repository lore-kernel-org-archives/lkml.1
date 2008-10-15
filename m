Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbYJOKmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYJOKmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 06:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYJOKmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 06:42:12 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:59174 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbYJOKmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:42:12 -0400
X-BigFish: VPS4(z34a4lz3117Kzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K8S0E3-01-L0W-01
Date: Wed, 15 Oct 2008 12:41:18 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: stable@kernel.org
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/2][stable] x86: check correctness of IRQ0 override on
	systems with ATI/AMD SB450/SB600 chipsets
Message-ID: <20081015104118.GA4706@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 15 Oct 2008 10:41:42.0554 (UTC) FILETIME=[9CBE3FA0:01C92EB2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

following patches should go into 2.6.27-stable tree.

They fix issues with HP Laptops that provide a wrong override for IRQ0
and which change the thermal trip point as soon as Linux unmasks
IOAPIC INT2.

See for instance following bugzillas:

http://bugzilla.kernel.org/show_bug.cgi?id=11516
http://bugzilla.kernel.org/show_bug.cgi?id=11715
http://bugzilla.kernel.org/show_bug.cgi?id=11719


Regards,

Andreas


