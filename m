Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbZAOJIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbZAOJIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbZAOJHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:07:13 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:23609 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbZAOJHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:07:08 -0500
Date: Thu, 15 Jan 2009 10:06:53 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Balaji Rao <balajirrao@openmoko.org>, LKML <linux-kernel@vger.kernel.org>
Subject: CONFIG_MFD_PCF50633=m breaks the kernel build
Message-ID: <20090115100653.509416fb@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balaji,

Building kernel 2.6.29-rc1-git4 on x86_64 with CONFIG_MFD_PCF50633=m
fails at linking time with:

ERROR: "__set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
ERROR: "handle_level_irq" [drivers/mfd/pcf50633-core.ko] undefined!

-- 
Jean Delvare
