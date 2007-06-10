Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbXFJMSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbXFJMSB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 08:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbXFJMRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 08:17:53 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:59575 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbXFJMRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 08:17:53 -0400
In-Reply-To: <1181474643.8351.1.camel@concordia.ozlabs.ibm.com>
References: <20070609201221.5868.31948.stgit@localhost.localdomain> <1181474643.8351.1.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <59594cddc7b5eb6e355fd01efef8ebcc@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, Auke Kok <auke-jan.h.kok@intel.com>,
       gregkh@suse.de, davem@davemloft.net, grundler@parisc-linux.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] PCI: also read revision ID for sparc64, ppc, read class at the same time
Date: Sun, 10 Jun 2007 14:17:48 +0200
To: michael@ellerman.id.au
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> +	dev->revision = get_int_prop(node, "revision-id", 0);
>
> It's not clear to me in the spec if nodes are required to have the
> "revision-id" property.

It is required for every PCI node.

> I guess 0 is a safe default though.

As good as any -- that is, no default is save.  0 should
be "good enough" here I guess.


Segher

