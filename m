Return-Path: <linux-kernel-owner+w=401wt.eu-S965971AbXCFSZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965971AbXCFSZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965968AbXCFSZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:25:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59543
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965971AbXCFSZx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:25:53 -0500
Date: Tue, 06 Mar 2007 10:25:51 -0800 (PST)
Message-Id: <20070306.102551.34761735.davem@davemloft.net>
To: ilmari@ilmari.org
Cc: andi@firstfloor.org, shemminger@linux-foundation.org,
       jengelh@linux01.gwdg.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC] div64_64 support II
From: David Miller <davem@davemloft.net>
In-Reply-To: <d8jlkiagte5.fsf@nygaard.ping.uio.no>
References: <20070305.162551.41660347.davem@davemloft.net>
	<20070306140412.GA1470@one.firstfloor.org>
	<d8jlkiagte5.fsf@nygaard.ping.uio.no>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: ilmari@ilmari.org (Dagfinn Ilmari Mannsåker)
Date: Tue, 06 Mar 2007 18:43:14 +0100

> Andi Kleen <andi@firstfloor.org> writes:
> 
> > Actually on rereading this: is there really any Linux port
> > that emulates multiplies in software? I thought that was only
> > done on really small microcontrollers or smart cards; but anything
> > 32bit+ that runs Linux should have hardware multiply, shouldn't it?
> 
> SPARCv7 (sun4/sun4c) doesn't have hardware mul/div. This includes
> SparcStation 1, 1+, 2, SLC, ELC, IPC and IPX.

Right and the cypress sun4m parts don't do multiply/divide in
hardware either.

I believe the Alpha does divide in software too, see
arch/alpha/lib/divide.S
