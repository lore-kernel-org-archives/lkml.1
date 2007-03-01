Return-Path: <linux-kernel-owner+w=401wt.eu-S965054AbXCANjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965054AbXCANjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965058AbXCANjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:39:55 -0500
Received: from sdcrelbas01.europe.hp.net ([15.203.169.187]:38142 "EHLO
	sdcrelbas01.sdc.hp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965054AbXCANjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:39:54 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: lanana: Add major/minor entries for PPC QE UART devices
Date: Thu, 1 Mar 2007 14:38:54 +0100
Message-ID: <93C4769E3BED6B42B7203BD6F065654C08C5DEC5@dmoexc01.emea.cpqcorp.net>
In-Reply-To: <A6EED9FC-4CE4-4089-ACB8-A1C7A3C50FDD@embeddedalley.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: lanana: Add major/minor entries for PPC QE UART devices
Thread-Index: AcdbexzgmW+EnodtTmq6QSS77Fo/hwAihB2w
References: <45E46976.6060600@freescale.com>	<29c13109971547687159078eacdea008@kernel.crashing.org>	<45E592DC.9060700@freescale.com>	<511cacb7bbe8a65ff72738c84ec9ece4@kernel.crashing.org>	<BD465924-7387-47EF-B90F-606F215819C2@embeddedalley.com>	<45E5B604.904@freescale.com> <46F6BF70-2922-4E05-8DAB-6B0830B0AB47@embeddedalley.com> <45E5BD6B.1010509@freescale.com> <F2D0230C-CA22-4DEF-917E-6982FA0C6171@embeddedalley.com> <45E5C128.7020204@freescale.com> <45E5C333.2060100@zytor.com> <ED6BD6F0-827F-4ADC-9D66-F9C3DD7FC470@embeddedalley.com> <E919B903-0890-4725-81CF-005003A1A2F6@kernel.crashing.org> <45E5D627.6030707@zytor.com> <45E5D84A.5000502@freescale.com> <278AADB6-E175-4177-A728-5357E21697B7@kernel.crashing.org> <45E5DB49.8010205@freescale.com> <A6EED9FC-4CE4-4089-ACB8-A1C7A3C50FDD@embeddedalley.com>
From: "Mathiasen, Torben" <Torben.Mathiasen@hp.com>
To: "Dan Malek" <dan@embeddedalley.com>, "Timur Tabi" <timur@freescale.com>
Cc: "Kumar Gala" <galak@kernel.crashing.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-ppc-embedded" <linuxppc-embedded@ozlabs.org>,
       "Segher Boessenkool" <segher@kernel.crashing.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Mar 2007 13:39:52.0446 (UTC) FILETIME=[170AD1E0:01C75C07]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We are making a very complicated problem
> out of nothing.  This hasn't caused any problems
> in the past, and changing the existing names and
> minors will cause problems for everyone today.
> 
> Just leave it alone, fix up the documentation,
> and have the driver print some warning if it
> allocates more than 4 UARTs.
> 

Dan has a point here. Now I clearly can't comment on how bad 8 is
needed, but since this has been like this for a while, I'll have to
assume 4 is covering most cases.

Moving things to a different range _will_ be much worse for distro
maintainers than driver developers. And I bet the latter is going to be
minor work as things has been like this for a while.

But we can still allocate 4 more at a different minor that distro's can
_choose_ to use. Consider it an enhancement to the 4 we have had in the
past.

Torben


