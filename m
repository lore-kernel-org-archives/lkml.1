Return-Path: <linux-kernel-owner+w=401wt.eu-S934220AbXIKVQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934220AbXIKVQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763635AbXIKVQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:16:13 -0400
Received: from smtp25.orange.fr ([193.252.22.22]:5451 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764094AbXIKVQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:16:12 -0400
X-Greylist: delayed 30735 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Sep 2007 17:16:12 EDT
X-ME-UUID: 20070911211609950.E80DD1C00086@mwinf2522.orange.fr
Subject: r8169: can't send magic packet for Wake-On-Lan
From: Xavier Bestel <xavier.bestel@free.fr>
To: linux-kernel@vger.kernel.org
Cc: shuchen@realtek.com.tw, romieu@fr.zoreil.com
Content-Type: text/plain
Date: Tue, 11 Sep 2007 23:16:06 +0200
Message-Id: <1189545366.4403.9.camel@bip.parateam.prv>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

with the r8169 I can't send a magic packet anymore. I'm using ethtool
for that, with the previous one (an rtl8139b) it was working very well.
ethtool -D apparently says it could send the packet ok.
The receiving side hasn't changed (it's an r8169 too), it's setup for
wake-on-lan and is soft-powered-off with ACPI as it should (no change in
config since a few years).

Do I have to set something special on the sending end ?

Thanks,

	Xav


