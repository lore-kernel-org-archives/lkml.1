Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYAUAcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYAUAcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 19:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbYAUAch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 19:32:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39602
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755027AbYAUAch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 19:32:37 -0500
Date: Sun, 20 Jan 2008 16:32:41 -0800 (PST)
Message-Id: <20080120.163241.80038143.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: Re: post 2.6.24-rc7 regression: unregister_netdevice: waiting for
 eth1 to become free
From: David Miller <davem@davemloft.net>
In-Reply-To: <200801210109.42153.m.kozlowski@tuxland.pl>
References: <200801210109.42153.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Mon, 21 Jan 2008 01:09:41 +0100

> kernel: unregister_netdevice: waiting for eth1 to become free. Usage count = 1

Known problem:

	http://bugzilla.kernel.org/show_bug.cgi?id=9778
