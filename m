Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbZFBK61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbZFBK61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 06:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbZFBK6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 06:58:20 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:57828 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbZFBK6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 06:58:20 -0400
From: Markus <M4rkusXXL@web.de>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Seagate Barracuda 7200.11 ST31500341AS fw SD17
Date: Tue, 2 Jun 2009 12:58:20 +0200
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906021258.20346.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX19fuUGv8TyoEWXgy5bsCRBwqlv7pWthMPM6fcrC
	pm6KDv9JQI/Uz8Rc76Vq4OrOaXgd4hogW3OgjcIqdAk9uPqby9
	WFgv5ntZc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have some Seagate Barracuda 7200.11 ST31500341AS 1.5TB drives. They 
use the firmware SD17.
They time out at the flush write cache and sometimes on the identify 
command.
I know that sounds suspicious so I wrote to seagate but they told me my 
drives are ok. (Although I dont think so.)

This drive+fw is blacklisted in the kernel, but there is no firmware 
upgrade for these drives. (Only very few serial numbers are able to 
upgrade.)

Now I want to know after what period of the time the kernel timeouts at 
these commands!? And if this timeout can be increased (manually, small 
patch for the kernel) and the min/max/avg time could somehow be 
messured. Every timeout kicks the drives off the raid, so I disabled 
the write cache (hdparm -W0 /dev/sdx) but thats no solution, just a bad 
workaround.

Its a amd64 system with the 2.6.29.4 on an AM3 board with AMDs 790GX + 
SB750 Chipsets running in ahci mode.

Thanks for your time and support!

Markus

PS: Please CC me!
