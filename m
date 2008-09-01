Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbYIALXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbYIALXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYIALXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:23:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:27385 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbYIALXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:23:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=jXioFihQwxLcVQHBY6Ix3lPFlvwy/7biyfX+TqXrCbpTl1qq45pdvOedP8JiVhOCLK
         mMAdFIiZpr9xr88OIOFpL0AdQWry8bDRqgGIf5ZVBFCzTlhwMWfY2ysoTn4K6pv9D24U
         2l5aQulsqeXhIWDNZCHSnCjvTuw0JwviZsgJ0=
Message-ID: <48BBD092.2040908@gmail.com>
Date: Mon, 01 Sep 2008 13:22:58 +0200
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: matt.jared@intel.com, andy.kopp@intel.com, dan.d.kogan@intel.com,
       lkml <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>, chaos.proton@gmail.com
Subject: Documentation/sound/alsa/ALSA-Configuration.txt: fix typo
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[contacts inb sound/pci/hda/hda_intel.c CCed]

As noted by Gu Rui in http://bugzilla.kernel.org/show_bug.cgi?id=11444,
there is a typo in Documentation/sound/alsa/ALSA-Configuration.txt.
After checking the source (sound/pci/hda/hda_intel.c), the report
looks correct to me.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

--- linux-2.6.27-rc2-orig/Documentation/sound/alsa/ALSA-Configuration.txt	2008-09-01 12:55:30.000000000 +0200
+++ linux-2.6.27-rc2/Documentation/sound/alsa/ALSA-Configuration.txt	2008-09-01 13:03:10.000000000 +0200
@@ -1079,7 +1079,7 @@
  	    register value without FIFO size correction as the current
  	    DMA pointer.  position_fix=2 will make the driver to use
  	    the position buffer instead of reading SD_LPIB register.
-	    (Usually SD_LPLIB register is more accurate than the
+	    (Usually SD_LPIB register is more accurate than the
  	    position buffer.)

      NB: If you get many "azx_get_response timeout" messages at
