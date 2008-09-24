Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYIXJBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYIXJBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 05:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYIXJB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 05:01:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44790
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751538AbYIXJB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 05:01:28 -0400
Date: Wed, 24 Sep 2008 02:01:16 -0700 (PDT)
Message-Id: <20080924.020116.193720569.davem@davemloft.net>
To: airlied@gmail.com
Cc: jkosina@suse.cz, jeffrey.t.kirsher@intel.com, david.vrabel@csr.com,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
From: David Miller <davem@davemloft.net>
In-Reply-To: <21d7e9970809240159u6db747eex51892061846b2251@mail.gmail.com>
References: <21d7e9970809232245x6a91c6e2l552ff039d07e2017@mail.gmail.com>
	<20080924.003638.71148740.davem@davemloft.net>
	<21d7e9970809240159u6db747eex51892061846b2251@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dave Airlie" <airlied@gmail.com>
Date: Wed, 24 Sep 2008 18:59:34 +1000

> On Wed, Sep 24, 2008 at 5:36 PM, David Miller <davem@davemloft.net> wrote:
> The driver seems quite happy to access the NVRAM, I think Thomas has
> some backtraces that show
> it clearly doing silly reentrant things...

I don't dispute that the locking is dodgy and likely needs to be fixed
like e1000.

I'm asking what userland tool or kernel event is triggering the nvram
access.

It shouldn't even touch the thing after probing and initializing
the card.
