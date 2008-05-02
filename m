Return-Path: <linux-kernel-owner+w=401wt.eu-S937318AbYEBXN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937318AbYEBXN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932513AbYEBXNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:13:16 -0400
Received: from mail0.lsil.com ([147.145.40.20]:55683 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393AbYEBXNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:13:15 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: HELP: Is writeq an atomic operation??
Date: Fri, 2 May 2008 17:13:08 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E822901047B4A@NAMAIL2.ad.lsil.com>
In-Reply-To: <adawsmc2u8n.fsf@cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: HELP: Is writeq an atomic operation??
thread-index: Acisp1whQrUdKCwCRPO+NeJUGNvO2wAAVyQQ
From: "Moore, Eric" <Eric.Moore@lsi.com>
To: "Roland Dreier" <rdreier@cisco.com>
Cc: "David Miller" <davem@davemloft.net>, <linux-scsi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 May 2008 23:13:08.0798 (UTC) FILETIME=[15AA9DE0:01C8ACAA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 02, 2008 4:53 PM, Roland Dreier wrote: 
> 
>  > > Are there any 32-bit platforms with writeq()?  A quick grep 
>  > > suggests not.
>  > 
>  > I think writeq defined in include/asm-x86/io_64.h
> 
> Umm... io_64.h is 64-bit only (look at asm-x86/io.h if you 
> don't believe me ;)
> 

Yeah,  I forgot I have a #ifndef writeq, then defined the x86_64 version
of that.   I've not tested on x86, so I'm not sure whether it works.
How are you handling writeq when its not defined, as the case in x86?

Eric

