Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbXF3PT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbXF3PT6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 11:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbXF3PTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 11:19:49 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:48239 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbXF3PTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 11:19:48 -0400
Date: Sat, 30 Jun 2007 16:19:23 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: =?iso-8859-1?B?VPZy9ms=?= Edvin <edwintorok@gmail.com>,
       netdev@vger.kernel.org, power@bughost.org, zambrano@broadcom.com,
       linux-kernel@vger.kernel.org
Message-ID: <20070630151923.GA22983@srcf.ucam.org>
References: <4354d3270706300447ladcda4by987b1f87963112f9@mail.gmail.com> <20070630120541.GA21339@srcf.ucam.org> <46866C6B.9010801@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46866C6B.9010801@linux.intel.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] b44: power down PHY when interface down
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 07:44:59AM -0700, Arjan van de Ven wrote:
> Matthew Garrett wrote:
> >Do you still get link beat detection when the phy is powered down?
> >
> does that matter?
> If the interface is down, nic drivers aren't expected to detect 
> link... if userspace wants to find link status it should have the 
> interface up.

If that's the policy, why do we leave this up to individual drivers? 
Right now most of them let you make the query regardless of interface 
state.

I'd agree that there's a need for a state where we power down as much as 
possible (even at the cost of functionality), but where possible it 
would also be nice to offer a state where the mac is powered down and 
the phy left up. If the existing semantics are confused then it would be 
nice to fix them, too.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
