Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbZGGPbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbZGGPbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbZGGPbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:31:32 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:34700 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbZGGPbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:31:32 -0400
Date: Tue, 07 Jul 2009 11:31:06 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: sfi-devel@simplefirmware.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: sfi tree build failure
In-reply-to: <20090707154353.628365ac.sfr@canb.auug.org.au>
Message-id: <alpine.LFD.2.00.0907071120230.4244@localhost.localdomain>
References: <20090630171937.75f64662.sfr@canb.auug.org.au>
 <20090706161432.111a42ee.sfr@canb.auug.org.au>
 <alpine.LFD.2.00.0907062348130.32467@localhost.localdomain>
 <20090707154353.628365ac.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I still get the same error.

git.kernel.org took a long time to update from master.kerne.org
last night.  (indeed, I was sending patches through e-mail to
some folks to work around it); so I suspect you pulled the SFI
tree before the mirror updated and got the same thing you
got over the weekend.

surfing to git.kernel.org, it seems to be up to date now.

The tree should include this one of interest:

commit 4844be551844e05d4b70f0624e9c34fd486d3e33
Author: Len Brown <len.brown@intel.com>
Date:   Mon Jul 6 23:57:55 2009 -0400

    SFI: revert changes to linux/acpi.h, fix ppc build

Note that Linus pulls from master.kernel.org rather than git.kernel.org
to avoid any possible sync delay between tree push and his pull.

If you have trouble with a copy of the tree that includes
the commit above, (I don't expect to see the same failure,
but it is always possible there is another one after this one),
then please send me the complete build log.

cheers,
-Len
