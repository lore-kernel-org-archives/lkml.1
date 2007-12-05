Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbXLEAk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbXLEAk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 19:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbXLEAks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 19:40:48 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:52422 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbXLEAkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 19:40:47 -0500
Date: Tue, 4 Dec 2007 20:39:25 -0400
From: Konrad Rzeszutek <konrad@darnok.org>
To: darnok@68k.org
Cc: Arjan van de Ven <arjan@infradead.org>, Doug Maxey <dwm@enoyolf.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       pjones@redhat.com, konradr@redhat.com, konradr@linux.vnet.ibm.com,
       randy.dunlap@oracle.com, hpa@zytor.com, lenb@kernel.org,
       mike.anderson@us.ibm.com, dwm@austin.ibm.com
Subject: Re: [PATCH] Add iSCSI IBFT Support (v0.3)
Message-ID: <20071205003925.GG6736@andromeda.dapyr.net>
References: <20071126225642.GA7973@andromeda.dapyr.net> <20071127033138.GB30770@kroah.com> <11870.1196136773@bebe.enoyolf.org> <200711262350.13100.konrad@darnok.org> <20071127150611.26a9575f@laptopd505.fenrus.org> <20071129153621.GA4669@andromeda.dapyr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129153621.GA4669@andromeda.dapyr.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 11:36:21AM -0400, darnok@68k.org wrote:
> > > 
> > > /sys/firmware/ibft/ethernet0/pci-bdf
> > > 5:1:0
> > 
> > shouldn't this somehow also have a symlink to the kernels ethX view of
> > ethernet devices?
> > (and if so.. how much of the info is duplicated..)
> 
> That NIC is used by the NIC firmware (or the BIOS) to negotiate
> the iSCSI target. The information that is in this directory is what
> the BIOS used (note past tense) which might very well be completly
> different from what Linux uses.
> 
> My rationale behind _not_ linking to ethX view was that it could
> be confusing and not entirely useful for users: "It says that _this_
> NIC, with this IP, uses this iSCSI target. But Linux is using a
> completly different NIC (and IP) to setup a iSCSI connection to the
> same iSCSI target!?"

On the other hand having a link to the device and being able to
extra data sounds good too. I've made a modification and posted
a new version, under the 'REPORT [PATCH] Add iSCSI iBFT v0.4'.

Review would be much appreciated.
