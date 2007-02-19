Return-Path: <linux-kernel-owner+w=401wt.eu-S932486AbXBSUD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbXBSUD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 15:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932515AbXBSUD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 15:03:26 -0500
Received: from gate.crashing.org ([63.228.1.57]:42916 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932486AbXBSUDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 15:03:25 -0500
Subject: Re: [PATCH 2.6.21-rc1] powerpc: Make
	of_device_uevent()	compatible	with ibmebus
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joachim Fenkes <FENKES@de.ibm.com>
Cc: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>, johnrose@us.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       pmac@au1.ibm.com, Sylvain Munaut <tnt@246tnt.com>
In-Reply-To: <OF18F067AE.FF85D78B-ON85257287.005ADAC3-85257287.005B37D9@de.ibm.com>
References: <OF18F067AE.FF85D78B-ON85257287.005ADAC3-85257287.005B37D9@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 Feb 2007 06:47:52 +1100
Message-Id: <1171914472.18571.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> If I make the root device a basic struct device, it can't be part of 
> ibmebus any
> longer. If we could create a busless device, we wouldn't have a problem, 
> but I
> doubt that is possible.
> 
> Do you have any creative ideas?

Well, I think PCI does just that for PCI busses ... (a busless device)

Ben.

> > It's a generic problem with sysfs, I agree it somewhat sucks.
> 
> With ya.
> 
> Later,
>   Joachim
> 
> ---
> Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer 
> extraordinaire
> IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Development 
> 2)
> Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
> eMail: fenkes@de.ibm.com  --  Phone: +49 7031 16 1239 
> 
> Vorsitzender des Aufsichtsrats: Johann Weihen  --  Geschäftsführung: 
> Herbert Kircher
> Sitz der Gesellschaft: Böblingen  --  Registergericht: Amtsgericht 
> Stuttgart, HRB 243294

