Return-Path: <linux-kernel-owner+w=401wt.eu-S1761016AbXGXTqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761016AbXGXTqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbXGXTpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:45:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58884
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752665AbXGXTpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:45:53 -0400
Date: Tue, 24 Jul 2007 12:45:52 -0700 (PDT)
Message-Id: <20070724.124552.72716820.davem@davemloft.net>
To: atporter@primate.net
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: miserable performance of 2.6.21 under network load
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070724184908.GD24543@primate.net>
References: <20070724172513.GB24543@primate.net>
	<p73vec9sknz.fsf@bingen.suse.de>
	<20070724184908.GD24543@primate.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Porter <atporter@primate.net>
Date: Tue, 24 Jul 2007 11:49:09 -0700

> samples  %        app name                 symbol name
> 914379   48.8404  vmlinux-2.6.21.5         check_poison_obj
> 341920   18.2632  vmlinux-2.6.21.5         poison_obj
> 37355     1.9953  nf_conntrack             (no symbols)

You have SLAB debugging enabled, turn it off if you want
decent performance.
