Return-Path: <linux-kernel-owner+w=401wt.eu-S1761840AbYBCOLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761840AbYBCOLj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 09:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935692AbYBCOL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 09:11:27 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:35819 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600AbYBCOL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 09:11:26 -0500
Date: Sun, 3 Feb 2008 15:11:25 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       petr@vandrovec.name
Subject: Commit f06e4ec breaks vmware
Message-ID: <Pine.LNX.4.64.0802020120150.18790@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


sad to say, but f06e4ec... breaks booting the kernel in vmware 
(bisected). Booting just stops after

	Checking for 'hlt' instruction...

commit f06e4ec1c15691b0cfd2397ae32214fa36c90d71
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jan 30 13:32:39 2008 +0100

    x86: read_tsc sync
    
    make native_read_tsc() always non-speculative.


Any debugging hintss?


thanks,
Jan
