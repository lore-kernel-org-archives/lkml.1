Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbXJ3VmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbXJ3VmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbXJ3VmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:42:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50553
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752499AbXJ3VmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:42:08 -0400
Date: Tue, 30 Oct 2007 14:41:52 -0700 (PDT)
Message-Id: <20071030.144152.75148636.davem@davemloft.net>
To: ak@suse.de
Cc: torvalds@linux-foundation.org, hancockr@shaw.ca, greg@kroah.com,
       jbarnes@virtuousgeek.org, akpm@linux-foundation.org,
       rajesh.shah@intel.com, linux-kernel@vger.kernel.org
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
From: David Miller <davem@davemloft.net>
In-Reply-To: <200710301950.58519.ak@suse.de>
References: <47267232.3020506@shaw.ca>
	<alpine.LFD.0.999.0710300811230.30120@woody.linux-foundation.org>
	<200710301950.58519.ak@suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@suse.de>
Date: Tue, 30 Oct 2007 19:50:58 +0100

> I believe the tigon3 driver also does config space access frequently
> on some chips.

This case is not worth optimizing for at all.
