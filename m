Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab0BRUAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 15:00:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50192 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758517Ab0BRUAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 15:00:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Subject: Re: [PATCH 4/8] ACPI: Use GPE reference counting to support shared GPEs
Date: Thu, 18 Feb 2010 21:01:44 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Gary Hade <garyhade@us.ibm.com>
References: <201002172335.47703.rjw@sisk.pl> <201002172341.07353.rjw@sisk.pl> <4B7CE6A3.7020103@np.css.fujitsu.com>
In-Reply-To: <4B7CE6A3.7020103@np.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <201002182101.44171.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 February 2010, Jin Dongming wrote:
> Hi, Rafael J. Wysocki
> > -	/* Update enable mask, but don't enable the HW GPE as of yet */
> > -
> > -	status = acpi_ev_enable_gpe(gpe_event_info, FALSE);

You could preserve some more context.

> I think the above line code should be remained. If it is deleted, the exception 
> event will be raised on some machine.

Why would it?  The GPE is still disabled at the hardware level at this point.

Rafael
