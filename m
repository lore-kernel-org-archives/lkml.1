Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbYBRHdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbYBRHdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 02:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbYBRHdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 02:33:39 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:42855 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbYBRHdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 02:33:38 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 4/6] Add multi mport support.
Date: Mon, 18 Feb 2008 15:33:31 +0800
Message-ID: <ABF87B0B6A38C0458E319AC973ED68AEC3DEFF@zch01exm26.fsl.freescale.net>
In-Reply-To: <20080205162942.GB20177@gate.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/6] Add multi mport support.
Thread-Index: AchoFFQgcgURDTc9QTKaMq6Vc4oWFgJ61igw
References: <1201689053956-git-send-email-wei.zhang@freescale.com> <12016890621727-git-send-email-wei.zhang@freescale.com> <120168907160-git-send-email-wei.zhang@freescale.com> <12016890773706-git-send-email-wei.zhang@freescale.com> <AF4B8466-C1CE-4FFB-8341-4BFC1CB76116@kernel.crashing.org> <ABF87B0B6A38C0458E319AC973ED68AEBD0677@zch01exm26.fsl.freescale.net> <EC566605-6890-4983-8700-3B15C9EFC1C5@kernel.crashing.org> <F2D2FCC7-D1ED-4DC6-BE7A-EE2755CCE125@kernel.crashing.org> <ABF87B0B6A38C0458E319AC973ED68AEBD0697@zch01exm26.fsl.freescale.net> <20080205162942.GB20177@gate.crashing.org>
From: "Zhang Wei" <Wei.Zhang@freescale.com>
To: "Matt Porter" <mporter@kernel.crashing.org>
Cc: "Kumar Gala" <galak@kernel.crashing.org>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Matt,

So glad to see you again!

> -----Original Message-----
> From: Matt Porter [mailto:mporter@kernel.crashing.org] 
> On Thu, Jan 31, 2008 at 02:30:13PM +0800, Zhang Wei wrote:
> > > -----Original Message-----
> > > From: Kumar Gala [mailto:galak@kernel.crashing.org] 
> > > when we have multiple ports are the device IDs on the 
> ports intended  
> > > to be unique only to a port or unique across all ports?
> > > 
> > I consider each RIO controller will has its own network, 
> the device IDs
> > should be
> > unique only in its port network.
> 
> This is a bad assumption IMHO. It pushes policy on to the system
> designer of a RapidIO network.

I know it is a real bad assumption. However, the RIO initial ID is only
transported to
 driver by kernel parameter "riohdid", which can not distinguish the
multi
 rio controllers. It may be more better add a "rio-id" property in RIO
dts node, but
 the u-boot need some changes to support the rio-id assignment.

Cheers!
Wei.
