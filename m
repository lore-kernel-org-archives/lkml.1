Return-Path: <linux-kernel-owner+w=401wt.eu-S1764195AbXF1JW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764195AbXF1JW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 05:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbXF1JWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 05:22:19 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:38315 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753361AbXF1JWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 05:22:19 -0400
In-Reply-To: <11829333481977-git-send-email-wei.zhang@freescale.com>
References: <11829333481420-git-send-email-wei.zhang@freescale.com> <11829333481977-git-send-email-wei.zhang@freescale.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <5f0438212493766009684d63e41c85cc@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       mporter@kernel.crashing.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/5 v2] Add the explanation and a sample of RapidIO DTS sector to the document of booting-without-of.txt file.
Date: Thu, 28 Jun 2007 11:22:14 +0200
To: Zhang Wei <wei.zhang@freescale.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +    - #address-cells : Address representation for "rapidio" devices.
> +      This field represents the number of cells needed to represent
> +      the RapidIO address of the registers.  For supporting more than
> +      32-bits RapidIO address, this field should be <2>.
> +      See 1) above for more details on defining #address-cells.

What does the RapidIO standard say about number of address
bits?  You want to follow that, so all RapidIO devices can
use the same #address-cells, not just the FSL ones.  Also,
are there different kinds of address spaces on the bus, or
is it just one big memory-like space?


Segher

