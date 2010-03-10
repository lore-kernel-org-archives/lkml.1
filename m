Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab0CJVMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 16:12:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48417 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757188Ab0CJVMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 16:12:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [Q] How to tell we're using the KMS (during suspend/resume) outside the graphics driver
Date: Wed, 10 Mar 2010 22:15:26 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Pauli Nieminen <suokkos@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Luca Tettamanti <kronos.it@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
References: <201003062236.09801.rjw@sisk.pl> <548cdfc21003100254t5c94aca5u5cf1e9eb29215325@mail.gmail.com> <20100310205618.GA28628@srcf.ucam.org>
In-Reply-To: <20100310205618.GA28628@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003102215.26232.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 March 2010, Matthew Garrett wrote:
> As far as the ACPI video driver goes, acpi_get_physical_pci_device() 
> will give you something to work with.

Hmm.  Did you mean acpi_get_physical_device()?

Which acpi_device should I call that for?

> For the console-switching case, I think the most reasonable plan is probably
> to add a flag to the console drivers to indicate whether or not they support
> reprogramming the hardware themselves, and then walk all active console
> drivers. There'd need to be a way for fb drivers to tell fbcon that they can
> handle it.

Yes, that sounds reasonable.

Rafael
