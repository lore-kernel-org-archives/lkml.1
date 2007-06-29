Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbXF2ECa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbXF2ECa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 00:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbXF2ECV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 00:02:21 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:35047 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbXF2ECU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 00:02:20 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/5 v2] Add the explanation and a sample of RapidIO DTS sector to the document of booting-without-of.txt file.
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Fri, 29 Jun 2007 12:01:47 +0800
Message-ID: <46B96294322F7D458F9648B60E15112C6F3281@zch01exm26.fsl.freescale.net>
In-Reply-To: <5f0438212493766009684d63e41c85cc@kernel.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/5 v2] Add the explanation and a sample of RapidIO DTS sector to the document of booting-without-of.txt file.
Thread-Index: Ace5ZdhhrIfnQk5ZSMGi8MQMxp/AUwAmzBLg
References: <11829333481420-git-send-email-wei.zhang@freescale.com> <11829333481977-git-send-email-wei.zhang@freescale.com> <5f0438212493766009684d63e41c85cc@kernel.crashing.org>
From: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
To: "Segher Boessenkool" <segher@kernel.crashing.org>
Cc: <paulus@samba.org>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>, <mporter@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Segher, 
 
> > +    - #address-cells : Address representation for 
> "rapidio" devices.
> > +      This field represents the number of cells needed to represent
> > +      the RapidIO address of the registers.  For 
> supporting more than
> > +      32-bits RapidIO address, this field should be <2>.
> > +      See 1) above for more details on defining #address-cells.
> 
> What does the RapidIO standard say about number of address
> bits?  You want to follow that, so all RapidIO devices can
> use the same #address-cells, not just the FSL ones.  Also,
> are there different kinds of address spaces on the bus, or
> is it just one big memory-like space?
> 
> 

I've checked the specification of RapidIO. The supporting of RapidIO
extended address modes are 66, 50 and 34 bit.
The Freescale's silicons is only support 34 bit address now.
Do you mean I should not use words -- 'should be <2>'?
The #address-cells should be assigned according the address mode
supported by silicon.

Thanks!
Wei.
