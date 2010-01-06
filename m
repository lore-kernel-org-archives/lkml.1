Return-Path: <linux-kernel-owner+w=401wt.eu-S932929Ab0AFVxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab0AFVxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932917Ab0AFVxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:53:33 -0500
Received: from outbound-mail-10.bluehost.com ([69.89.17.210]:39639 "HELO
	outbound-mail-10.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932907Ab0AFVxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:53:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ebZ4RSvsyAtmpNbi0krNbzMrPHPHiqIklDonpfExnHudeqX6Ox+AIzWH1VdGc+NajSvOHl7cX2qeC/4EfQEhD4fSojTv7WZEhrVdLTH63nUWHcZ5C071oEqjzzxM5Q2G;
Date: Wed, 6 Jan 2010 13:53:30 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: [PATCH 3/12] PCI PM: PCIe PME root port service driver (rev. 5)
Message-ID: <20100106135330.44baa6d3@jbarnes-piketon>
In-Reply-To: <200912272101.25036.rjw@sisk.pl>
References: <200912272057.10443.rjw@sisk.pl>
	<200912272101.25036.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Dec 2009 21:01:24 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> PCIe native PME detection mechanism is based on interrupts generated
> by root ports or event collectors every time a PCIe device sends a
> PME message upstream.
> 
> Once a PME message has been sent by an endpoint device and received
> by its root port (or event collector in the case of root complex
> integrated endpoints), the Requester ID from the message header is
> registered in the root port's Root Status register.  At the same
> time, the PME Status bit of the Root Status register is set to
> indicate that there's a PME to handle.  If PCIe PME interrupt is
> enabled for the root port, it generates an interrupt once the PME
> Status has been set.  After receiving the interrupt, the kernel can
> identify the PCIe device that generated the PME using the Requester
> ID from the root port's Root Status register. [For details, see PCI
> Express Base Specification, Rev. 2.0.]
> 
> Implement a driver for the PCIe PME root port service working in
> accordance with the above description.
> 
> Based on a patch from Shaohua Li <shaohua.li@intel.com>.

This one looks pretty nice.

-- 
Jesse Barnes, Intel Open Source Technology Center
