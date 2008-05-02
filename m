Return-Path: <linux-kernel-owner+w=401wt.eu-S937275AbYEBWuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937275AbYEBWuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759690AbYEBWuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:50:04 -0400
Received: from mail0.lsil.com ([147.145.40.20]:54593 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934517AbYEBWuC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:50:02 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: HELP: Is writeq an atomic operation??
Date: Fri, 2 May 2008 16:49:55 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E822901047B3A@NAMAIL2.ad.lsil.com>
In-Reply-To: <adaabj8499n.fsf@cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: HELP: Is writeq an atomic operation??
thread-index: AcispgClQPV/WxKNTHiL+QL181S70AAAFbBw
From: "Moore, Eric" <Eric.Moore@lsi.com>
To: "Roland Dreier" <rdreier@cisco.com>, "David Miller" <davem@davemloft.net>
Cc: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 May 2008 22:49:56.0137 (UTC) FILETIME=[D7936990:01C8ACA6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > 
>  > The answer to this question this is platform dependent.
>  > 
>  > On most 64-bit platforms, it is.  On some 32-bit ones, it is not.
> 
> Are there any 32-bit platforms with writeq()?  A quick grep 
> suggests not.

I think writeq defined in include/asm-x86/io_64.h

> 
> Are there any 64-bit platforms where writeq() allows the MMIO to be
> split into multiple cycles from the target device's view?  I've been
> coding assuming that at least no other MMIO writes will reach 
> the device
> in the middle of a writeq().
> 

I hope that is the case.
