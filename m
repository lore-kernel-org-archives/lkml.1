Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbZGPApf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbZGPApf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 20:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZGPApf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 20:45:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:51697 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbZGPApe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 20:45:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,407,1243839600"; 
   d="scan'208";a="165515551"
Subject: Re: [PATCH] ACPI: add driver for SMBus Control Method Interface
From: ykzhao <yakui.zhao@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>, Crane Cai <crane.cai@amd.com>
Cc: Crane Cai <crane.cai@amd.com>, "lenb@kernel.org" <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090715140057.GB19054@srcf.ucam.org>
References: <20090715060219.GA30514@crane-desktop>
	 <1247651002.4113.9.camel@localhost.localdomain>
	 <20090715140057.GB19054@srcf.ucam.org>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Thu, 16 Jul 2009 08:46:14 +0800
Message-Id: <1247705174.4113.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 22:00 +0800, Matthew Garrett wrote:
> On Wed, Jul 15, 2009 at 05:43:22PM +0800, ykzhao wrote:
> > On Wed, 2009-07-15 at 14:02 +0800, Crane Cai wrote:
> > > This driver supports the SMBus Control Method Interface. It needs BIOS declare
> > > ACPI control methods via SMBus Control Method Interface Spec.
> > It seems that SM bus control is realized in BIOS. And OS can use the
> > given control method interface to access it. 
> > Will this controller be accessed directly directly BIOS?
> > If it can be accessed by BIOS, how to resolve the conflict between BIOS
> > and OS?
> 
> It's being accessed via ACPI methods, so the vendors have the 
> opportunity to implement proper locking.
If the vendors can implement the proper locking, there will be no
conflict. 

Another issue is that this driver had better be put in the directory of
driver/platform/x86/.
Thanks.
> 
> > In fact we see the conflict on some boxes. The SMbus controller will be
> > accessed by BIOS. If the corresponding driver is loaded for the SMBUS
> > controller, there exists the potential risk. In such case we will hide
> > the SMbus controller or not load the device driver for it.
> 
> I don't think that's a risk in this case.
> 

