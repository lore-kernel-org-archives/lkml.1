Return-Path: <linux-kernel-owner+w=401wt.eu-S1758982AbXK2PkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982AbXK2PkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 10:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbXK2Pj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 10:39:58 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:51100 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbXK2Pj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 10:39:58 -0500
From: darnok@68k.org
Date: Thu, 29 Nov 2007 11:36:21 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Doug Maxey <dwm@enoyolf.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com
Subject: Re: [PATCH] Add iSCSI IBFT Support (v0.3)
Message-ID: <20071129153621.GA4669@andromeda.dapyr.net>
References: <20071126225642.GA7973@andromeda.dapyr.net> <20071127033138.GB30770@kroah.com> <11870.1196136773@bebe.enoyolf.org> <200711262350.13100.konrad@darnok.org> <20071127150611.26a9575f@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127150611.26a9575f@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > /sys/firmware/ibft/ethernet0/pci-bdf
> > 5:1:0
> 
> shouldn't this somehow also have a symlink to the kernels ethX view of
> ethernet devices?
> (and if so.. how much of the info is duplicated..)

That NIC is used by the NIC firmware (or the BIOS) to negotiate
the iSCSI target. The information that is in this directory is what
the BIOS used (note past tense) which might very well be completly
different from what Linux uses.

My rationale behind _not_ linking to ethX view was that it could
be confusing and not entirely useful for users: "It says that _this_
NIC, with this IP, uses this iSCSI target. But Linux is using a
completly different NIC (and IP) to setup a iSCSI connection to the
same iSCSI target!?"

