Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbXLIHRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbXLIHRB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 02:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbXLIHQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 02:16:54 -0500
Received: from gate.crashing.org ([63.228.1.57]:38619 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbXLIHQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 02:16:53 -0500
Subject: Re: [PATCH] pci: Fix bus resource assignment on 32 bits with 64b
	resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Greg KH <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071207010001.GA23575@kroah.com>
References: <20071205064116.D849BDE10A@ozlabs.org>
	 <1196911347.7033.15.camel@pasglop> <20071206063940.GA16474@kroah.com>
	 <1196927934.7033.39.camel@pasglop>  <20071207010001.GA23575@kroah.com>
Content-Type: text/plain
Date: Sun, 09 Dec 2007 18:16:34 +1100
Message-Id: <1197184594.6572.31.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-06 at 17:00 -0800, Greg KH wrote:
> But that is how we already handle this today, in numerous places in
> the
> kernel for this very type.
> 
> So, you can disagree that this is what we need to do, and if so, feel
> free to fix up a whole lot of files in the tree :)

Heh, ok, allright, I'll respin with the casts.

Cheers,
Ben.


