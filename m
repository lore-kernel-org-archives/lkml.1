Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYKGTgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYKGTgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYKGTgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:36:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53907
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751358AbYKGTgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:36:46 -0500
Date: Fri, 07 Nov 2008 11:36:45 -0800 (PST)
Message-Id: <20081107.113645.46315945.davem@davemloft.net>
To: kay.sievers@vrfy.org
Cc: wli@holomorphy.com, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: sparc: struct device - replace bus_id with dev_name(),
 dev_set_name()
From: David Miller <davem@davemloft.net>
In-Reply-To: <ac3eb2510811070158i40ea64adq93511426e5c86ab7@mail.gmail.com>
References: <ac3eb2510811070033m108d8ed5t499c20ee02b2618f@mail.gmail.com>
	<20081107.013833.147302570.davem@davemloft.net>
	<ac3eb2510811070158i40ea64adq93511426e5c86ab7@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kay Sievers" <kay.sievers@vrfy.org>
Date: Fri, 7 Nov 2008 10:58:09 +0100

> Yeah, but the thing is, that _I_ don't want to remove any checks or
> limits from subsystem code. While touching hundreds of files the last
> days, there are several instances which could break if I remove any
> limits. And most of the stuff I can not even compile.
> 
> I can let the BUS_ID_SIZE in the header, but I rather have the people
> who understand the code to change the behavior.

That's right.  My main point is that if you don't keep the key
in there to grep for, nobody is likely to make the cleanups.
Nobody is going to grep for "20".

> Anyway, care to apply the first hunk, and skip the "20" part? I'll
> remove the "20" part from the net/ patch too and resend it.

Sure.
