Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbYLJF1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbYLJF1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 00:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYLJF0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 00:26:54 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:59805 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYLJF0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 00:26:53 -0500
Date: Wed, 10 Dec 2008 00:26:48 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [stable] [PATCH 2.6.23..2.6.27.stable] ACPI: delete OSI(Linux) DMI
 dmesg spam
In-reply-to: <20081209173914.GC32344@kroah.com>
X-X-Sender: lenb@localhost.localdomain
To: Greg KH <greg@kroah.com>
Cc: stable@kernel.org, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.2.00.0812100023150.17146@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <alpine.LFD.2.00.0812081556060.4406@localhost.localdomain>
 <20081209173914.GC32344@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Per 2.6.28 commit a6e0887f21bbab337ee32d9c0a84d7c0b6e9141b,
> > stop soliciting DMI info for this BIOS issue.
> > 
> > Signed-off-by: Len Brown <len.brown@intel.com>
> 
> I don't understand, this isn't commit a6e0887f21bb upstream, right?
> 
> Is this patch upstream?  Or is it just that you don't want to get these
> messages anymore because it is fixed in 2.6.28 now?

We could port the upstream patch to the old .stable releases,
but I though it would cause less conflicts to instead
apply this simpler version that doesn't touch the DMI lists.

The reason we're turning off this message is because
at this point we don't think we'll learn anything new from additional
user feedback.

thanks,
-Len Brown
Intel Open Source Technology Center
