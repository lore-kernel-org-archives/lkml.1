Return-Path: <linux-kernel-owner+w=401wt.eu-S1763412AbXLTX4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763412AbXLTX4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbXLTX4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:56:36 -0500
Received: from gate.crashing.org ([63.228.1.57]:48592 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbXLTX4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:56:35 -0500
Subject: Re: patch
	pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch added
	to gregkh-2.6 tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: gregkh@suse.de
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <11981938363358@kroah.org>
References: <11981938363358@kroah.org>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 10:56:13 +1100
Message-Id: <1198194973.6779.35.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The current pci_assign_unassigned_resources() code doesn't work properly
> on 32 bits platforms with 64 bits resources. The main reason is the use
> of unsigned long in various places instead of resource_size_t.
> 
> This fixes it, along with some tricks to avoid casting to 64 bits on
> platforms that don't need it in every printk around.

Can you still edit the changelog ? If yes, please remove that sentence
since the latest version (which you put in your tree) doesn't actually
have those tricks anymore as per discussion on the list...

Sorry about that.

Cheers,
Ben.

