Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbXCXP6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbXCXP6f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 11:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXCXP6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 11:58:35 -0400
Received: from linux6.nezu.wide.ad.jp ([203.178.142.218]:60738 "EHLO
	nezu.linux-ipv6.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbXCXP6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 11:58:34 -0400
Date: Sun, 25 Mar 2007 00:52:27 +0900 (JST)
Message-Id: <20070325.005227.432838064.takamiya@linux-ipv6.org>
To: linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, usagi-core@linux-ipv6.org
Subject: [PATCH 0/2] [SERIAL] [USB] fixed to skip NULL entry in struct
 serial usb_serial_port.
From: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>
X-Face: +<)&j!Ce24nM@a.\f6TA,]^9Q76[_QN_[QR-(bT&>b40Oo[:`R(>b7!b-|q5k&.8CO[_Oh_
 !9Nk0rikK70~?|08EFH|:]iF6pwPlnfEn-wo-voY:rP?%7p%cxjnbf'hglO'se&QwZN7/RVX!U7*P%
 cTV('HfHp+?g1+hx7\+J.W]<O~hbwx[4hPPO=T<7aV2^7["&p^h4:YbY6,bS,ecZ7S5<pIUTnT''}k
 ={TEs)bN%-8Jdo~.Q_lpa-fN^.Fo9dFB*}\@=PK@0pmvZ3k0p-5hMQ<bjyK{enk/sOQ[<(k]}Q\p>G
 zYWv%LsDc
X-Mailer: Mew version 5.1 on XEmacs 21.4.17 (Jumbo Shrimp)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  When I boot using linux-2.6.21-rc4 on ThinkPad T41 with pl2303 USB
  serial device plugged in, the kernel crashes.

  The reason is struct usb_serial_port is referenced without checking
  whether it is NULL or not.

  Regards,

--
Noriaki TAKAMIYA

