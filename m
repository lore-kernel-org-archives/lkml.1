Return-Path: <linux-kernel-owner+w=401wt.eu-S932986Ab0AFXA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab0AFXA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932187Ab0AFXA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:00:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40960 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124Ab0AFXAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:00:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 4/12] PCI PM: Make it possible to force using INTx for PCIe PME signaling
Date: Thu, 7 Jan 2010 00:00:41 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Francois Romieu <romieu@fr.zoreil.com>
References: <200912272057.10443.rjw@sisk.pl> <20100106135625.14b37f10@jbarnes-piketon> <20100106220214.GA25366@srcf.ucam.org>
In-Reply-To: <20100106220214.GA25366@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001070000.41807.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 January 2010, Matthew Garrett wrote:
> On Wed, Jan 06, 2010 at 01:56:25PM -0800, Jesse Barnes wrote:
> 
> > This scares me a little... seems like we're not restoring some state on
> > resume that's needed for MSIs to work?  Looks fine though.
> 
> Yeah, that was my concern. We debugged this a little on IRC and didn't 
> get anywhere, though, so probably need to find someone who knows more 
> about MSIs...

I'd rather say someone who knows more about ICH7. :-)

MSIs work just fine after resume for the other devices in the same box,
so I'd say it's a chipset issue.

Rafael
