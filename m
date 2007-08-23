Return-Path: <linux-kernel-owner+w=401wt.eu-S933914AbXHWWqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914AbXHWWqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbXHWWqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:46:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:61612 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759835AbXHWWqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:46:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=Y2SJ8nQR7URQbRvGpqgbgMUZC2KVciEiUTesvEnvv7lyi/srGrbSiLlsbeIBZaeSJsIvQqZ9cuAAr7h5U92yIVGLc4alBqDwVnyRXFj3Jp5P23dtdGBK6MBYYCf16MXdi1ZBBre1zbFWZpo646vxzU/6o8ywAdZA/1em0VvxZLc=
Message-ID: <46CE0DCC.30206@googlemail.com>
Date: Fri, 24 Aug 2007 00:44:28 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Luca Risolia <luca.risolia@studio.unibo.it>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: drivers/media/video/et61x251/et61x251_core.c - compile error
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luca ,

I got the following compile error with a randconfig on current git head :

...

drivers/media/video/et61x251/et61x251_core.c: In function 'et61x251_show_reg':
drivers/media/video/et61x251/et61x251_core.c:718: error: implicit declaration of function 'to_video_device'
drivers/media/video/et61x251/et61x251_core.c:718: warning: passing argument 1 of 'video_get_drvdata' makes pointer from integer without a cast
drivers/media/video/et61x251/et61x251_core.c: In function 'et61x251_store_reg':
drivers/media/video/et61x251/et61x251_core.c:742: warning: passing argument 1 of 'video_get_drvdata' makes pointer from integer without a cast
drivers/media/video/et61x251/et61x251_core.c: In function 'et61x251_show_val':
drivers/media/video/et61x251/et61x251_core.c:774: warning: passing argument 1 of 'video_get_drvdata' makes pointer from integer without a cast
drivers/media/video/et61x251/et61x251_core.c: In function 'et61x251_store_val':
drivers/media/video/et61x251/et61x251_core.c:806: warning: passing argument 1 of 'video_get_drvdata' makes pointer from integer without a cast
drivers/media/video/et61x251/et61x251_core.c: In function 'et61x251_show_i2c_reg':
drivers/media/video/et61x251/et61x251_core.c:842: warning: passing argument 1 of 'video_get_drvdata' makes pointer from integer without a cast
drivers/media/video/et61x251/et61x251_core.c: In function 'et61x251_store_i2c_reg':
drivers/media/video/et61x251/et61x251_core.c:868: warning: passing argument 1 of 'video_get_drvdata' makes pointer from integer without a cast
drivers/media/video/et61x251/et61x251_core.c: In function 'et61x251_show_i2c_val':
drivers/media/video/et61x251/et61x251_core.c:900: warning: passing argument 1 of 'video_get_drvdata' makes pointer from integer without a cast
drivers/media/video/et61x251/et61x251_core.c: In function 'et61x251_store_i2c_val':
drivers/media/video/et61x251/et61x251_core.c:937: warning: passing argument 1 of 'video_get_drvdata' makes pointer from integer without a cast
make[4]: *** [drivers/media/video/et61x251/et61x251_core.o] Error 1
make[3]: *** [drivers/media/video/et61x251] Error 2
make[2]: *** [drivers/media/video] Error 2
make[1]: *** [drivers/media] Error 2
make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....

... 


config : http://194.231.229.228/kernel/randconfig-et61x251_core


Regards,

Gabriel
