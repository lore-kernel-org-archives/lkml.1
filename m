Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbXHPLBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbXHPLBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 07:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbXHPLBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 07:01:24 -0400
Received: from mail.suse.de ([195.135.220.2]:46411 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbXHPLBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 07:01:22 -0400
Date: Thu, 16 Aug 2007 13:01:16 +0200
From: Karsten Keil <kkeil@suse.de>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Joe Perches <joe@perches.com>,
       Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, rolandd@cisco.com,
       Chas Williams <chas@cmf.nrl.navy.mil>, Paul Mundt <lethal@linux-sh.org>,
       isdn4linux@listserv.isdn4linux.de, mikep@linuxtr.net,
       Netdev <netdev@vger.kernel.org>, swen@vnet.ibm.com, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, jdike@karaya.com,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net,
       netfilter-devel@lists.netfilter.org, coreteam@netfilter.org,
       Satyam Sharma <satyam@infradead.org>
Subject: Re: drivers/infiniband/mlx/mad.c misplaced ;
Message-ID: <20070816110116.GA8100@pingi.kke.suse.de>
Mail-Followup-To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Joe Perches <joe@perches.com>, Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, rolandd@cisco.com,
	Chas Williams <chas@cmf.nrl.navy.mil>,
	Paul Mundt <lethal@linux-sh.org>, isdn4linux@listserv.isdn4linux.de,
	mikep@linuxtr.net, Netdev <netdev@vger.kernel.org>,
	swen@vnet.ibm.com, linux390@de.ibm.com, linux-s390@vger.kernel.org,
	jdike@karaya.com, user-mode-linux-devel@lists.sourceforge.net,
	user-mode-linux-user@lists.sourceforge.net,
	netfilter-devel@lists.netfilter.org, coreteam@netfilter.org,
	Satyam Sharma <satyam@infradead.org>
References: <20070815235825.GB17004@redhat.com> <1187224811.5906.55.camel@localhost> <20070816084635.GA15985@osiris.boeblingen.de.ibm.com> <Pine.LNX.4.64.0708161248050.22579@kivilampi-30.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0708161248050.22579@kivilampi-30.cs.helsinki.fi>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.27-0.6-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 01:22:04PM +0300, Ilpo Järvinen wrote:
> 
> ...I guess those guys hunting for broken busyloops in the other thread 
> could also benefit from similar searching commands introduced in this 
> thread... ...Ccing Satyam to caught their attention too.
> 
> 
> ./drivers/isdn/hisax/hfc_pci.c
> 125:	if (Read_hfc(cs, HFCPCI_INT_S1)) ;
> 155:	if (Read_hfc(cs, HFCPCI_INT_S1)) ;
> 1483:					if (Read_hfc(cs, HFCPCI_INT_S1)) ;
> --
> ./drivers/isdn/hisax/hfc_sx.c
> 377:	if (Read_hfc(cs, HFCSX_INT_S1)) ;
> 407:	if (Read_hfc(cs, HFCSX_INT_S2)) ;
> 1246:					if (Read_hfc(cs, HFCSX_INT_S1)) ;
> --

These are workaround to not get compiler warnings about ignored return
values I got some time ago under some architecture.


-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
