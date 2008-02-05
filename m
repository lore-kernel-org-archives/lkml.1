Return-Path: <linux-kernel-owner+w=401wt.eu-S1758297AbYBEQHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbYBEQHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbYBEQGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:06:41 -0500
Received: from gate.crashing.org ([63.228.1.57]:48039 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbYBEQGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:06:40 -0500
Cc: Zhang Wei <wei.zhang@freescale.com>, mporter@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-Id: <4A9328DB-F68C-4C09-B762-44FEA85DD12E@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20080205164425.b6af5bff.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH 5/6] Add OF-tree support to RapidIO controller driver.
Date: Tue, 5 Feb 2008 10:06:04 -0600
References: <1201689053956-git-send-email-wei.zhang@freescale.com> <12016890621727-git-send-email-wei.zhang@freescale.com> <120168907160-git-send-email-wei.zhang@freescale.com> <12016890773706-git-send-email-wei.zhang@freescale.com> <12016890832943-git-send-email-wei.zhang@freescale.com> <20080205164425.b6af5bff.sfr@canb.auug.org.au>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 4, 2008, at 11:44 PM, Stephen Rothwell wrote:

>>
>> +	aw = *(u32 *)of_get_property(dev->node, "#address-cells", NULL);
>> +	sw = *(u32 *)of_get_property(dev->node, "#size-cells", NULL);
>
> What happens if either of these properties is missing?

Should we add __must_check to of_get_property?

- k
