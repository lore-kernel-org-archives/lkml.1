Return-Path: <linux-kernel-owner+w=401wt.eu-S1764923AbYAaGQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764923AbYAaGQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 01:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYAaGQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 01:16:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:50492 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbYAaGQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 01:16:41 -0500
Cc: <mporter@kernel.crashing.org>, <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>
Message-Id: <F84DDA3A-AF43-4E88-B971-2C9C89733FF1@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Zhang Wei <wei.zhang@freescale.com>
In-Reply-To: <ABF87B0B6A38C0458E319AC973ED68AEBD0683@zch01exm26.fsl.freescale.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH 1/6] Change RIO function mpc85xx_ to fsl_ .
Date: Thu, 31 Jan 2008 00:15:07 -0600
References: <1201689053956-git-send-email-wei.zhang@freescale.com> <A3EAB036-F69D-48DD-8CA9-4EAAE63AE1F5@kernel.crashing.org> <ABF87B0B6A38C0458E319AC973ED68AEBD0683@zch01exm26.fsl.freescale.net>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 31, 2008, at 12:04 AM, Zhang Wei wrote:

> All right, I'll give you another patch for 86xx dts file. :)
>
> Btw: Why the PCI and other nodes were moved from SOC? Just for clear?
> If they are moved out, their register address must use full address  
> not
> offset address.

we did this because the feeling was the SOC node just represented the  
IMMR/CCSBAR registers, and not the address space used by the various  
busses.

(this is why pci, rio, and local bus all exist outside of the soc node).

- k
