Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbZDVF6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbZDVF6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 01:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZDVF5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 01:57:49 -0400
Received: from night.yars.free.net ([193.233.48.54]:59169 "EHLO
	night.yars.free.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbZDVF5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 01:57:48 -0400
Date: Wed, 22 Apr 2009 09:57:35 +0400
From: "Alexander V. Lukyanov" <lav@netis.ru>
To: linux-kernel@vger.kernel.org
Subject: 2.6.29.1: unregister_netdevice problem
Message-ID: <20090422055735.GA4334@night.netis.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eventually I have an increased load average without apparent reason.
When I reboot the server in such a case, I get infinitely repeating
messages on the console:

unregister_netdevice: waiting for eth0.2 to become free. Usage count = 4

eth0.2 is a vlan interface, eth0 is 02:00.0 Ethernet controller: Realtek
Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet
controller (rev 01)

-- 
   Alexander.
