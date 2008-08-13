Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYHMVLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYHMVLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 17:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYHMVLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 17:11:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:2505 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbYHMVLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 17:11:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=WWY8nZ0VEhMdBvvSW+aCvzUNPyF43H2gFoE7lH9efS55CYd5nlWIDfJW+iGl3qa20D
         lEJskc7YFxGUapQnSGdMh5vUrsUtIrhyjfQKi9FMB+6KAevBbur1+Ysz/ScFoInOhcoT
         Di9PpLSJ8262LU8sWfy2EOxChC7NPaDgWBsO0=
Message-ID: <1ba2fa240808131411o638311f1m2e2daa6ef62057b1@mail.gmail.com>
Date: Thu, 14 Aug 2008 00:11:24 +0300
From: "Tomas Winkler" <tomas.winkler@intel.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net, "Zhu Yi" <yi.zhu@intel.com>
Subject: [ANNOUNCE] Wifi Link 5300 and 5100 Series
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: dc4c1f22c353e69d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel would like to announce Linux support  for Wifi Link 5000 and
5100 Series Adapters under iwlwifi driver (iwlagn.ko)

The Intel(R) WiFi Link 5100 Series and 5300 is a families of IEEE
802.11a/b/g/Draft-N1 wireless network
adapters that operate in both the 2.4 GHz and 5.0 GHz spectra. These
adapters, available
in both PCIe* Mini Card and Half Mini Card form factor
5100 1x2 MIMO up to 300Mbps
5300 3x3 MIMO up to 450Mbps

Note: in 2.6.27-rc3 the MIMO and QoS features are not operational due
to recent changes in MQ. This has probably hit also other wireless
drivers We are working on resolving these issues.

The best known working driver can be located in iwl500 branch of
iwlwifi-2.6.git
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git iwl5000

It is based 2.6.26-rc6 wireless-testing kernel.
We will publish compat-wireless that works with this release for easy
back porting to earlier stable kernels.

The driver requires firmware that can be downloaded from
http://intellinuxwireless.org


pci.ids were already sent to http://pciids.sourceforge.net
----------------------------------
8086  Intel Corporation
        4232 Wifi Link 5100 Wireless Adapter
                8086 1201 5100ABGN Mini Card
                8086 1205 5100BG Mini Card
                8086 1206 5100ABG Mini Card
                8086 1301 5100ABGN Half Mini Card
                8086 1305 5100BG Half Mini Card
                8086 1306 5100ABG Half Mini Card
                8086 1321 5100ABGN Half Mini Card Dell
                8086 1326 5100ABG Half Mini Card Dell
        4235 Wifi Link 5300 Wireless Adapter
                8086 1001 5300ABGN Mini Card
                8086 1101 5300ABGN Half Mini Card
                8086 1121 5300ABGN Half Mini Card Dell
        4236 Wifi Link 5300 Wireless Adapter
                8086 1011 5300ABGN Mini Card Lenovo
        4237 Wifi Link 5100 Wireless Adapter
                8086 1211 5100ABGN Mini Card Lenovo
                8086 1216 5100ABG Mini Card Lenovo

----------------------

Tomas
