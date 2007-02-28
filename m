Return-Path: <linux-kernel-owner+w=401wt.eu-S932281AbXB1NR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbXB1NR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 08:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932282AbXB1NR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 08:17:27 -0500
Received: from sdcrelbas03.europe.hp.net ([15.203.169.189]:38161 "EHLO
	sdcrelbas03.sdc.hp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932281AbXB1NR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 08:17:26 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: lanana: Add major/minor entries for PPC QE UART devices
Date: Wed, 28 Feb 2007 14:14:41 +0100
Message-ID: <93C4769E3BED6B42B7203BD6F065654C08C5D7FF@dmoexc01.emea.cpqcorp.net>
In-Reply-To: <45E57CE5.5010003@zytor.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: lanana: Add major/minor entries for PPC QE UART devices
Thread-Index: AcdbOHLmOEtottJ1TmSRY7fKC0rHQAAAejVw
References: <45E46976.6060600@freescale.com> <93C4769E3BED6B42B7203BD6F065654C08C5D6E8@dmoexc01.emea.cpqcorp.net> <45E57CE5.5010003@zytor.com>
From: "Mathiasen, Torben" <Torben.Mathiasen@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Timur Tabi" <timur@freescale.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 Feb 2007 13:17:20.0090 (UTC) FILETIME=[C68FEBA0:01C75B3A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Mathiasen, Torben wrote:
> >
> > Got around looking at this one. I'm fine with this approach, but the
> > CPM5 fix looks wrong. Shouldn't it be:
> >
> > 49 = /dev/ttyCPM3		PPC CPM (SCC or SMC) - port 3
> >
> > instead?
> >
> 
> Well, how many CPM devices can exist?  If there are really 6 ports
> possible, they need minors up to 51.
> 
> Also, if QE really is just CPM v3, and they share the same minors, why
> change the name?
> 

Assuming QE has 4 entries, I would expect CPM to be the same. But we
need verification of that. If it needs 6, we are in more trouble.

Torben
