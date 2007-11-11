Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbXKKQLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbXKKQLd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 11:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbXKKQLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 11:11:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbXKKQLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 11:11:24 -0500
To: "Keith Chew" <keith.chew@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCI card initialisation at boot
From: Andi Kleen <andi@firstfloor.org>
References: <20f65d530711110722k3d2bf658hb44ceaa036b9962c@mail.gmail.com>
Date: Sun, 11 Nov 2007 17:11:23 +0100
In-Reply-To: <20f65d530711110722k3d2bf658hb44ceaa036b9962c@mail.gmail.com> (Keith Chew's message of "Mon\, 12 Nov 2007 04\:22\:15 +1300")
Message-ID: <p73mytkzrro.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Keith Chew" <keith.chew@gmail.com> writes:
>
> My question is: Will setting the BIOS to "Resource allocation by
> Manual" prevent the crash from happening in the future? More
> specifically, does Linux still depend on ESCD even if the resource
> allocation is set to Manual?

Linux does not directly use the ESCD, but it uses configuration coming
from the BIOS (like PCI bridge setup or ACPI resources) that might
depend on the ESCD depending on your BIOS implementation.

You would probably need to ask someone familiar with your BIOS what
the ESCD influences in your configuration and what Manual allocation
changes exactly.

Most likely the real fix would be to add a checksum to it, but 
only the BIOS can do that.

-Andi
