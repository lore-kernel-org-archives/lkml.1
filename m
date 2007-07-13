Return-Path: <linux-kernel-owner+w=401wt.eu-S936971AbXGMUtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936971AbXGMUtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 16:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760340AbXGMUtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 16:49:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:64559 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759738AbXGMUtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 16:49:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=i//BK4ChAg7WePiuWYjMEpK0CHZirdNhUsEyZcCi/ESZMl+vp03EfjWtADeSS/SDhsbq5h5PdS9SNs2zb0LrNQs1xyQJ6u1UWIDxz6qsC54zVF3ieUqkJjA0c8Cym2n7jJUs6Q98VL77/cMUybytB4HSeNNUBoGpMAir0BfbmJc=
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: keyboard stopped working after de9ce703c6b807b1dfef5942df4f2fadd0fdb67a
Date: Fri, 13 Jul 2007 22:49:25 +0200
User-Agent: KMail/1.9.5
Cc: Dmitry Torokhov <dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707132249.26106.christophpfister@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After a kernel update I recognised that my keyboard sometimes didn't work 
after booting up. I found out that the issue appeared quite reliably after a 
cold reboot and not pressing any key (for example not selecting stuff at the 
bootloader) till the machine fully booted up.
Because git head (4eb6bf6bfb580afaf1e1a1d30cba17a078530cf4) didn't solve the 
problem I did a bisect and your commit was found to be the culprit (the 
second last build succeeded 5 of 5 times during my tests and the last build 
failed 2 of 3 times).

Can anybody please shade light on this?

Thanks,

Christoph
