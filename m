Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbZG2AcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbZG2AcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZG2AcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 20:32:09 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:29847 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbZG2AcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 20:32:08 -0400
Date: Tue, 28 Jul 2009 18:32:08 -0600
From: Alex Chiang <achiang@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, kernelnewbies@nl.linux.org
Subject: Re: [PATCH] Shut off pci_find_device warnings when the deprecated
	pci functions are enabled.
Message-ID: <20090729003208.GB3539@ldl.fc.hp.com>
References: <20090724094115.GA18450@basil.fritz.box> <20090728095552.72c41525@jbarnes-g45> <20090729001613.GA19369@ldl.fc.hp.com> <20090729002801.GR15310@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729002801.GR15310@basil.fritz.box>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org>:
> > Maybe it's too late now, but I thought those warnings were
> > supposed to motivate people to convert old, buggy drivers to get
> > off the deprecated interface.
> 
> Yes they are, but this warning instance was not for a old driver,
> but for the EXPORT_SYMBOL defining the legacy function.
> 
> If any driver uses it it'll still warn.

Ok, I've been corrected. :)

I still think it would be a good learning project for someone to
audit the tree and see if they can eliminate the usages of
pci_find_device().

Thanks,

/ac

