Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbXK2PH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbXK2PH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 10:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932242AbXK2PG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 10:06:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35481 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499AbXK2PG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 10:06:57 -0500
Date: Tue, 27 Nov 2007 15:06:11 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: Doug Maxey <dwm@enoyolf.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com
Subject: Re: [PATCH] Add iSCSI IBFT Support (v0.3)
Message-ID: <20071127150611.26a9575f@laptopd505.fenrus.org>
In-Reply-To: <200711262350.13100.konrad@darnok.org>
References: <20071126225642.GA7973@andromeda.dapyr.net>
	<20071127033138.GB30770@kroah.com>
	<11870.1196136773@bebe.enoyolf.org>
	<200711262350.13100.konrad@darnok.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 23:50:10 -0500
Konrad Rzeszutek <konrad@darnok.org> wrote:

> > >
> > > sysfs files have ONE VALUE PER FILE, not a whole bunch of
> > > different things in a single file.  Please fix this.
> >
> > The subparameters _are_ actually part of a single value, that value
> > being associated with the initiator instance.
> >
> > Konrad is trying to implement a "work-alike" for what open firmware
> > does. open-iscsi already has the ability to extract the same format
> > bits from real OFW.
> >
> > See open-iscsi.git/utils/fwparam_ppc.
> 
> 
> Greg,
> 
> In light of what Doug says (which is all true), should I go ahead
> with a new version of this module which would export one value per
> file? The problem that will be encountered is that a ethernetX sysfs
> directory would have (for example):
> 
> /sys/firmware/ibft/ethernet0/pci-bdf
> 5:1:0

shouldn't this somehow also have a symlink to the kernels ethX view of
ethernet devices?
(and if so.. how much of the info is duplicated..)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
