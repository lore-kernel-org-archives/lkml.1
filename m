Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbYAaF6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbYAaF6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 00:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbYAaF6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 00:58:07 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:41914 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbYAaF6E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 00:58:04 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 4/6] Add multi mport support.
Date: Thu, 31 Jan 2008 13:57:25 +0800
Message-ID: <ABF87B0B6A38C0458E319AC973ED68AEBD0677@zch01exm26.fsl.freescale.net>
In-Reply-To: <AF4B8466-C1CE-4FFB-8341-4BFC1CB76116@kernel.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/6] Add multi mport support.
Thread-Index: AchjTEv0WH1413JAT1qoW+ZByD2nWwAbjP0g
References: <1201689053956-git-send-email-wei.zhang@freescale.com> <12016890621727-git-send-email-wei.zhang@freescale.com> <120168907160-git-send-email-wei.zhang@freescale.com> <12016890773706-git-send-email-wei.zhang@freescale.com> <AF4B8466-C1CE-4FFB-8341-4BFC1CB76116@kernel.crashing.org>
From: "Zhang Wei" <Wei.Zhang@freescale.com>
To: "Kumar Gala" <galak@kernel.crashing.org>
Cc: <mporter@kernel.crashing.org>, <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Kumar Gala [mailto:galak@kernel.crashing.org] 
> 
> On Jan 30, 2008, at 4:30 AM, Zhang Wei wrote:
> 
> > Change lots of static variable to mport private. And add 
> mport to some
> > function declaration.
> 
> Can you explain this patch further.  Its not clear exactly from this  
> commit message why we are doing this.
> 
> - k

Sorry about I have a little hurry about it.

The original RapidIO driver suppose there is only one mpc85xx RIO
controller
in system. So, some data structures are defined as mpc85xx_rio global,
such as 'regs_win', 'dbell_ring', 'msg_tx_ring'. Now, I changed them to
mport's private members. And you can define multi RIO OF-nodes in dts
file
for multi RapidIO controller in one processor, such as PCI/PCI-Ex host
controllers
in Freescale's silicon. And the mport operation function declaration
should be changed
to know which RapidIO controller is target.

Thanks!
Wei

