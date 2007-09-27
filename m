Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbXI0JEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbXI0JEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 05:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbXI0JEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 05:04:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:59808 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbXI0JEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 05:04:35 -0400
Subject: Re: 2.6.23-rc7 - _random_ IRQ23 : nobody cared
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Paul Rolland <rol@as2917.net>
Cc: Tejun Heo <htejun@gmail.com>, David Newall <david@davidnewall.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>, rol@witbe.net
In-Reply-To: <20070927080551.424e90b9@tux.DEF.witbe.net>
References: <20070924083336.7a08fd61@tux.DEF.witbe.net>
	 <46F7C933.4080003@davidnewall.com>
	 <20070925090057.5778aa2a@tux.DEF.witbe.net> <46FAFF7A.5070208@gmail.com>
	 <20070927080551.424e90b9@tux.DEF.witbe.net>
Content-Type: text/plain
Date: Thu, 27 Sep 2007 19:04:11 +1000
Message-Id: <1190883851.6158.18.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Let me guess... this is a T61 or X61 ?

There's a problem with these that we don't fully understand yet, we're
getting those stale interrupts all over the range.

I wonder if it could be a bug with the ICH8 chipset... 

If yours is one of these, it's being dealt with (or attempted to deal
with) at

http://bugzilla.kernel.org/show_bug.cgi?id=8853

Ben.


