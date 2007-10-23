Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbXJWXOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbXJWXOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 19:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbXJWXOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 19:14:47 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:40756 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbXJWXOq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 19:14:46 -0400
X-Greylist: delayed 549 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2007 19:14:46 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [HP ProLiant WatchDog driver] hpwdt HP WatchDog Patch <resend>
Date: Tue, 23 Oct 2007 23:04:58 -0000
Message-ID: <66ED1F0546CFFE4BABB226CD6633D4A6016D9941@G3W0635.americas.hpqcorp.net>
In-Reply-To: <20071023212032.GA26597@infradead.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [HP ProLiant WatchDog driver] hpwdt HP WatchDog Patch <resend>
Thread-Index: AcgVuo9OcAwVRRfTSa2QlMB1CxRP7wADjYSA
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Helgaas, Bjorn" <bjorn.helgaas@hp.com>
Cc: <linux-kernel@vger.kernel.org>, "Wim Van Sebroeck" <wim@iguana.be>
X-OriginalArrivalTime: 23 Oct 2007 23:05:00.0334 (UTC) FILETIME=[2334ECE0:01C815C9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We will never have more than one iLO2 device in a server so no multiple
instances are possible. 

Tom 

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Tuesday, October 23, 2007 4:21 PM
To: Helgaas, Bjorn
Cc: Mingarelli, Thomas; linux-kernel@vger.kernel.org; Wim Van Sebroeck
Subject: Re: [HP ProLiant WatchDog driver] hpwdt HP WatchDog Patch
<resend>

On Tue, Oct 23, 2007 at 02:31:15PM -0600, Bjorn Helgaas wrote:
> The driver assumes only a single instance of the device.  But PCI 
> being what it is, it's often possible to have multiple cards, so you 
> might want some protection in case you trip over more than one.

Yes.  And even with that protection please move all the global variables
into some per-device structure.  That makes the code a lot more
understandable and future-proof in case multiple devices of this type
may appear somewhere.

