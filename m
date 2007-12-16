Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbXLPSiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbXLPSiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 13:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbXLPSiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 13:38:18 -0500
Received: from mail.gatrixx.com ([217.111.11.44]:33566 "EHLO mail.gatrixx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbXLPSiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 13:38:17 -0500
X-Greylist: delayed 1924 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Dec 2007 13:38:17 EST
Message-ID: <4765690C.6010605@j-o-a.de>
Date: Sun, 16 Dec 2007 19:06:04 +0100
From: Oliver Joa <oliver@j-o-a.de>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: How to Switch DMA off for only one Harddisk at Kernelboot
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

how can I tell the kernel not to probe DMA for a specific harddisk (e.g. 
hda). My first Drive (hda) is a Compact-Flash Card which can not do DMA. 
The kernel tries at boot to switch to DMA but fails. If I use ide=nodma, 
the kernel boots about 2 minutes faster, but then I can not switch on 
DMA for the second Drive (hdc) which is a normal Harddisk. Do I have to 
live with this 2 minutes waiting time or is there another solution? I 
did not find any kernel-parameter for this purpose.

Sorry if I ask here, but I can not find any solution, and I asked 
already in other groups.

Thank you very much

Olli
