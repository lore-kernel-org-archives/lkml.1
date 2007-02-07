Return-Path: <linux-kernel-owner+w=401wt.eu-S1161445AbXBGVyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161445AbXBGVyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 16:54:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422816AbXBGVyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 16:54:07 -0500
Received: from hermes.domdv.de ([193.102.202.1]:2703 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161445AbXBGVyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 16:54:05 -0500
X-Greylist: delayed 932 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Feb 2007 16:54:05 EST
Message-ID: <45CA46D9.6090902@domdv.de>
Date: Wed, 07 Feb 2007 22:38:33 +0100
From: Andreas Steinmetz <ast@domdv.de>
User-Agent: Mail/News 1.5.0.7 (X11/20060915)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: [2.6.20] net/ieee80211/ieee80211_crypt_tkip.c spams kernel message
 buffer
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

net/ieee80211/ieee80211_crypt_tkip.c outputs tons of these which didn't
happen with 2.6.18.2 (only one or two of these after enabling the
ipw2200 with the kill switch):

TKIP: replay detected: STA=00:0e:2e:94:84:c3 previous TSC 020000000000
received TSC 00000002e560
printk: 19 messages suppressed.
TKIP: replay detected: STA=00:0e:2e:94:84:c3 previous TSC 020000000000
received TSC 00000002e574
printk: 19 messages suppressed.
TKIP: replay detected: STA=00:0e:2e:94:84:c3 previous TSC 020000000000
received TSC 00000002e588
printk: 18 messages suppressed.
TKIP: replay detected: STA=00:0e:2e:94:84:c3 previous TSC 020000000000
received TSC 00000002e59b
printk: 19 messages suppressed.
TKIP: replay detected: STA=00:0e:2e:94:84:c3 previous TSC 020000000000
received TSC 00000002e5af
printk: 19 messages suppressed.
TKIP: replay detected: STA=00:0e:2e:94:84:c3 previous TSC 020000000000
received TSC 00000002e5c3
printk: 19 messages suppressed.
TKIP: replay detected: STA=00:0e:2e:94:84:c3 previous TSC 020000000000
received TSC 00000002e5d7
printk: 19 messages suppressed.
TKIP: replay detected: STA=00:0e:2e:94:84:c3 previous TSC 020000000000
received TSC 00000002e5eb
printk: 19 messages suppressed.
TKIP: replay detected: STA=00:0e:2e:94:84:c3 previous TSC 020000000000
received TSC 00000002e5ff
printk: 16 messages suppressed.
TKIP: replay detected: STA=00:0e:2e:94:84:c3 previous TSC 020000000000
received TSC 00000002e612
printk: 17 messages suppressed.
TKIP: replay detected: STA=00:0e:2e:94:84:c3 previous TSC 020000000000
received TSC 00000002e626

-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
