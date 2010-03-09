Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab0CISnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:43:40 -0500
Received: from smtp110.plus.mail.re1.yahoo.com ([69.147.102.73]:33347 "HELO
	smtp110.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752004Ab0CISnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:43:37 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 13:43:37 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:Reply-To:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Mbzco1qMAp/1T1Jh2bdtHtfVj71OeeRCITHlQj9kcoMvK5fcagO99YO9RxExqV1oQ+u4YbqgWvAuprIAo22JdUzI0s2nyQHZdwh6Tjjll50LZDlW/LFIgFDIyYsyUPOAYoWHZtkjtOZtIYIGRhhF2Kv1Ri0LEafG/abH5qB+XKo=  ;
X-Yahoo-SMTP: YgQnr1KswBCtEU8oddRNxsdyzIgvXxo-
X-YMail-OSG: R1Kb5hQVM1nZIDA85VusDks5tv09uAIpCMguGMo22FSYrG8FhQPoCwFI1BXHDJEniJelkq2hwCzyXqNR2b1PYm54u4m84md.XernYmixY8OC2HTzX1eA43jCyadAY6nC22dVkAYtfdx_e1DMiJWQHFUhqYPjt1DbQ4lJYt_n2rchUHjpmCirgtNRao19fzFitxyB6cFxX0SY3v7lOKp5NhtWoxboRzN1V2uG2uzFT7lBhJGBMgSOujssh1d2q4a04YgkzpaWeuXkpfDaFzOuyL3ltcP70hAls8C_Y8XBIsR_1A5AAsNWgH3wpZnUxGzcp4ldqPYUVUY0yiT1Nv2Zfej5V0MRhu5rhkBjmJdm_YlBJrEcXS6nbgpboACVpBu6nFE9GGeWt_jJPo7xKKdQ.8eHNtrB7PXkg4sUpXH.jrLWLB5Imapjc_f3L3RTyJ6I_.AXBiP7Q0DJDo5llKp9KB8GYtjI6domgy_8hCqWBAzClPg-
X-Yahoo-Newman-Property: ymail-3
From: aseem sethi <aseemsethi@yahoo.com>
Reply-To: aseemsethi@yahoo.com
To: gregkh@suse.de, wfp5p@virginia.edu
Subject: [PATCH] Staging: comedi:fix missing KERN_facility level in ni_labpc.c
Date: Wed, 10 Mar 2010 00:04:36 +0530
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003100004.36422.aseemsethi@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: aseemsethi <aseemsethi@yahoo.com>
 This is a patch to fix the "missing KERN_facility level" error found when running the checkpatch.pl script
 Signed-off-by: Aseem Sethi <aseemsethi@yahoo.com>

---
 drivers/staging/comedi/drivers/ni_labpc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 3c88caa..63853c2 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -535,7 +535,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
        printk("\n");
 
        if (iobase == 0) {
-               printk("io base address is zero!\n");
+               printk(KERN_ERR "io base address is zero!\n");
                return -EINVAL;
        }
        /*  request io regions for isa boards */
-- 
1.6.4.2
__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
