Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbYCMDYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbYCMDYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 23:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYCMDYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 23:24:13 -0400
Received: from bay0-omc3-s23.bay0.hotmail.com ([65.54.246.223]:42233 "EHLO
	bay0-omc3-s23.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751584AbYCMDYM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 23:24:12 -0400
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Mar 2008 23:24:12 EDT
Message-ID: <BAY101-W12A3C20A292C4D1841E697C8090@phx.gbl>
X-Originating-IP: [76.197.169.130]
From: Adam Turk <bofh1234@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: please fix 2.6.24.3 unifdef-y += if_addrlabel.h problem
Date: Wed, 12 Mar 2008 23:17:00 -0400
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 13 Mar 2008 03:16:59.0686 (UTC) FILETIME=[B349B460:01C884B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

Can we please get a 2.6.24.4 kernel with the [patch 14/38] NET: Add if_addrlabel.h to sanitized headers patch reverted?  

author	Stephen Hemminger 
	Fri, 15 Feb 2008 09:31:32 +0000 (01:31 -0800)
committer	Greg Kroah-Hartman 
	Tue, 26 Feb 2008 00:18:35 +0000 (16:18 -0800)
commit	5fb7ba76544d95bfa05199f7394a442de5660be7
tree	40e96d63be55bab749e3840108595e30c68d402c
parent	e2a0956c9d1c9eebd51849c58fcbc7477c618a19

As it stands I can't compile a kernel without removing:

-- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -219,6 +219,7 @@ unifdef-y += i2c-dev.h
 unifdef-y += icmp.h
 unifdef-y += icmpv6.h
 unifdef-y += if_addr.h
-unifdef-y += if_addrlabel.h
 unifdef-y += if_arp.h
 unifdef-y += if_bridge.h
 unifdef-y += if_ec.h

Thanks,

_________________________________________________________________
Helping your favorite cause is as easy as instant messaging. You IM, we give.
http://im.live.com/Messenger/IM/Home/?source=text_hotmail_join