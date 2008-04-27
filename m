Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbYD0K7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbYD0K7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 06:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbYD0K7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 06:59:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:4479 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbYD0K7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 06:59:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Gl0CT4t5hU3dViCEZXqYAFwWMOrx2xaspySmM0/mNfNMUB5OiuASi9cvUc+EV/Tj9UYo7i7oOOU8Ewrgwn4swxAcL1xLGyn3Gf40aGVxpNJu/Lqtj+ICmS7Mj9iH8/jNKFbMMS/vOcnZYHhEEmGC3UWWJlZY9r8jHbZxcvsNegU=
Message-ID: <c878e2290804270359w4fe4392flc41a5fb074152572@mail.gmail.com>
Date: Sun, 27 Apr 2008 12:59:44 +0200
From: "Kim Hansen" <kimhanse@gmail.com>
To: "Alex Dubov" <oakad@yahoo.com>, linux-kernel@vger.kernel.org
Subject: tifm_7xx1: SD card is ignored
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have the problem that the SD card slot does not work on my Toshiba
Protege M400 with my current kernel (2.6.24), it worked for me with
2.6.18 but has been broken at least since 2.6.22.

The problem is that nothing happens, dmesg is silent and I guess the
cause is that the driver does not see the hardware.

How should I start debugging this?

raph:~# lspci
[...]
03:0b.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia
Card Reader (SD/MMC/MS/MS PRO/xD)
03:0b.3 SD Host controller: Texas Instruments PCIxx12 SDA Standard
Compliant SD Host Controller
raph:~# lsmod | grep tifm
tifm_sd                10888  0
tifm_7xx1               7360  0
mmc_core               47300  2 tifm_sd,sdhci
tifm_core               9956  2 tifm_sd,tifm_7xx1
raph:~# dmesg | grep -i tifm
raph:~#

PS: I am not subscribed to lkml, please cc me on replies.
-- 
Kim Hansen
Vadgårdsvej 3, 2.tv
2860 Søborg
Fastnet: 3956 2437 -- Mobil: 3091 2437
