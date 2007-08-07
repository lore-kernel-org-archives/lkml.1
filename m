Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbXHGIVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbXHGIVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 04:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbXHGIVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 04:21:39 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:38162 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbXHGIVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 04:21:37 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: i386: kernel boot fail at check_irq_resend:69
Date: Tue, 7 Aug 2007 16:21:29 +0800
Message-ID: <989B956029373F45A0B8AF029708189001190014@zch01exm26.fsl.freescale.net>
In-Reply-To: <a8e1da0708062332w4492eba9u2085f96fe5aefced@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: i386: kernel boot fail at check_irq_resend:69
Thread-Index: AcfYvOkyL1io7SZnQWGRN5Nmq9TH1AADljsw
References: <a8e1da0708062332w4492eba9u2085f96fe5aefced@mail.gmail.com>
From: "Li Yang-r58472" <LeoLi@freescale.com>
To: "Dave Young" <hidave.darkstar@gmail.com>, <hpa@zytor.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Dave Young
> Sent: Tuesday, August 07, 2007 2:32 PM
> To: hpa@zytor.com
> Cc: LKML
> Subject: i386: kernel boot fail at check_irq_resend:69
> 
> Hi,
> The kernerl 2.6.23-rc1-mm2 boot fail at check_irq_resend:69
>        > if (WARN_ON_ONCE(desc->handle_irq != handle_edge_irq))
>        >        return;

Failed?  It's just a kernel Badness for me, and the boot can be finished.

This is a known problem, and should be fixed soon.  See: http://lkml.org/lkml/2007/8/4/204

- Leo
