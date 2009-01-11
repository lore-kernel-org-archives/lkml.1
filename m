Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbZAKMIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbZAKMIy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 07:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZAKMIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 07:08:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37888
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751367AbZAKMIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 07:08:41 -0500
Date: Sun, 11 Jan 2009 04:08:42 -0800 (PST)
Message-Id: <20090111.040842.86784676.davem@davemloft.net>
To: Valdis.Kletnieks@vt.edu
Cc: alessandro.suardi@gmail.com, jaswinderlinux@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       dwmw2@infradead.org
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading
 (-git7 is ok)
From: David Miller <davem@davemloft.net>
In-Reply-To: <43805.1231672258@turing-police.cc.vt.edu>
References: <5a4c581d0901090930j5d4760b0x730b5609fa2b5614@mail.gmail.com>
	<20090109.140422.60087297.davem@davemloft.net>
	<43805.1231672258@turing-police.cc.vt.edu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valdis.Kletnieks@vt.edu
Date: Sun, 11 Jan 2009 06:10:58 -0500

> On Fri, 09 Jan 2009 14:04:22 PST, David Miller said:
> > From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
> > Date: Fri, 9 Jan 2009 18:30:40 +0100
> > 
> > > Clearly the requirement changed in -git8, AFAICS.
> > 
> > Because -git8 is where the firmware requirement got added.
> > 
> > If you build the TG3 driver statically into your kernel,
> > the only way to get the firmware properly loaded is to
> > enable that CONFIG_FIRMWARE_IN_KERNEL option.
> 
> Maybe this is one of those cases where we actually do want a SELECT?
> 
> 	select FIRMWARE_IN_KERNEL if TIGON3=y
> 
> or similar?

I have no idea how this is intended to work, David will
know.
