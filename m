Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbYH1Tbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbYH1Tbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYH1Tbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:31:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33860
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753932AbYH1Tbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:31:34 -0400
Date: Thu, 28 Aug 2008 12:31:29 -0700 (PDT)
Message-Id: <20080828.123129.176935353.davem@davemloft.net>
To: denys@visp.net.lb
Cc: andi@firstfloor.org, jmalicki@metacarta.com, johnpol@2ka.mipt.ru,
       dada1@cosmosbay.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, juhlenko@akamai.com, sammy@sammy.net
Subject: Re: loaded router, excessive getnstimeofday in oprofile
From: David Miller <davem@davemloft.net>
In-Reply-To: <200808281802.17867.denys@visp.net.lb>
References: <21915755.1327801219904892242.JavaMail.root@ouachita>
	<20080828072218.GI26610@one.firstfloor.org>
	<200808281802.17867.denys@visp.net.lb>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Fedoryshchenko <denys@visp.net.lb>
Date: Thu, 28 Aug 2008 18:02:17 +0300

> It seems i cannot test current net-2.6, because it is broken for me 
> on USB part (fixed by workaround in init scripts), HPET totally broken in 
> net-2.6, but works for latest main git from torvalds tree.
> I have to wait when net-2.6 rebased to current torvalds tree, then i will try 
> to test.

Make a clone of Linus's tree, then pull in the net-2.6 tree.

This is always how you should test things especially if you want to
make sure you have whatever non-networking bug fixes your machine
might require.
