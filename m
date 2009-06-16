Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbZFPH3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbZFPH3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 03:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZFPH3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 03:29:25 -0400
Received: from exprod7og114.obsmtp.com ([64.18.2.215]:54690 "HELO
	exprod7og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752053AbZFPH3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 03:29:24 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2009 03:29:24 EDT
MIME-Version: 1.0
Date: Tue, 16 Jun 2009 16:54:24 +0930
Message-ID: <2e115de50906160024r7c3140d6sc8744e4362d36ef8@mail.gmail.com>
Subject: is_device_dma_capable
From: Malcom Blaney <malcolm.blaney@maptek.com.au>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm using the parport_pc driver with a dma buffer, which is provided
by calling dma_alloc_coherent in arch/x86/include/asm/dma-mapping.h.

This is no longer working for me in 2.6.29.2, the previous version I
was using is 2.6.25.10, which was fine with the same hardware.

The problem is that the call to is_device_dma_capable returns false,
so dma_alloc_coherent returns NULL. Do I need to set the dma_mask in
the driver for this to work correctly?

thanks,
Malcolm.
