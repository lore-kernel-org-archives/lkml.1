Return-Path: <linux-kernel-owner+w=401wt.eu-S1761324AbZDCGyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761324AbZDCGyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZDCGyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:54:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56050 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbZDCGym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:54:42 -0400
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH] Add support for turning PCIe ECRC on or off
From: Andi Kleen <andi@firstfloor.org>
References: <20090402221751.11757.36392.stgit@bob.kio>
Date: Fri, 03 Apr 2009 08:54:39 +0200
In-Reply-To: <20090402221751.11757.36392.stgit@bob.kio> (Andrew Patterson's message of "Thu, 02 Apr 2009 16:17:51 -0600")
Message-ID: <87ljqikz0w.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Patterson <andrew.patterson@hp.com> writes:

> Add support for turning PCIe ECRC on or off
>
> Adds support for PCI Express transaction layer end-to-end CRC checking
> (ECRC).  This patch will enable/disable ECRC checking by setting/clearing
> the ECRC Check Enable and/or ECRC Generation Enable bits for devices that
> support ECRC.
>
> The ECRC setting is controlled by the "pcie_ecrc=" command-line option. If
> this option is not set or is set to 'default", the enable and generation
> bits are left in whatever state that firmware/BIOS sets them to.  The
> "off" setting turns them off, and the "on" option turns them on (if the
> device supports it).

Can you please expand a little bit on your motvation? Why does the kernel
need to set that over the firmware? And why does it need to be a boot
parameter vs some sysfs file?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
