Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbZIQCUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbZIQCUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 22:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbZIQCUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 22:20:39 -0400
Received: from outbound-mail-318.bluehost.com ([67.222.54.250]:57516 "HELO
	outbound-mail-318.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750941AbZIQCUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 22:20:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=HcZyeke9sKw09E08UmzsHn6LtrEbd/u4LT+3WdT0702IW7zb01XNJVvtfg93d1DZw6+67KSQZ39/43/9HEjroBBUwgQAMlo4LTtapy3DjdtFkPftMbmeuKUQMgpsMUVS;
Date: Wed, 16 Sep 2009 19:20:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Allen Kay <allen.m.kay@intel.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [ACS v2 1/1] clean up base on Matt Wilcox feedback.
Message-ID: <20090916192035.24302d24@jbarnes-g45>
In-Reply-To: <20090917021841.GL29320@parisc-linux.org>
References: <1253153261-23398-1-git-send-email-allen.m.kay@intel.com>
	<20090917021841.GL29320@parisc-linux.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009 20:18:41 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Sep 16, 2009 at 07:07:41PM -0700, Allen Kay wrote:
> > +/* Access Control Service */
> > +#define  PCI_ACS_CAP		0x04	/* ACS Capability
> > Register */ +#define  PCI_ACS_CTRL		0x06	/*
> > ACS Control Register */ +#define  PCI_ACS_EGRESS_CTL_V
> > 0x08	/* ACS Egress Control Vector */ +#define
> > PCI_ACS_SV		0x01	/* Source Validation */
> > +#define  PCI_ACS_TB		0x02	/* Translation
> > Blocking */ +#define  PCI_ACS_RR		0x04	/* P2P
> > Request Redirect */ +#define  PCI_ACS_CR
> > 0x08	/* P2P Completion Redirect */ +#define
> > PCI_ACS_UF		0x10	/* Upstream Forwarding */
> > +#define  PCI_ACS_EC		0x20	/* P2P Egress
> > Control */ +#define  PCI_ACS_DT		0x40	/*
> > Direct Translated P2P */
> 
> Oops, I wasn't clear.  The convention in this file is to use one space
> after the #define for register names and two spaces for bits within
> those registers.  Also, the bits generally go after the register to
> which they apply.
> 
> So what I meant was more like this:
> 
> #define PCI_ACS_CAP		0x04	/* ACS Capability
> Register */ #define  PCI_ACS_SV		0x01	/* Source
> Validation */ #define  PCI_ACS_TB		0x02	/*
> Translation Blocking */ #define  PCI_ACS_RR
> 0x04	/* P2P Request Redirect */ ...
> #define PCI_ACS_CTRL		0x06	/* ACS Control
> Register */ #define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS
> Egress Control Vector */
> 
> Since the bits are the same between CAP and CTRL, they don't need to
> be repeated.
> 
> With this change,
> 
> Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

Allen, easiest for me if you respin with Matthew's suggestion and a
full changelong + Matthew's reviewed-by.  Then I can just git am it.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
