Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbZJZUyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbZJZUyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZJZUyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:54:04 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46989 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZJZUyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:54:02 -0400
Date: Mon, 26 Oct 2009 13:53:41 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Crane Cai <crane.cai@amd.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       lenb@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/2] acpi: support IBM SMBus CMI devices
Message-ID: <20091026205341.GQ26149@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20091020231149.GM26149@tux1.beaverton.ibm.com> <20091021023016.GC32413@crane-desktop> <200910210857.13978.bjorn.helgaas@hp.com> <20091021173733.GN26149@tux1.beaverton.ibm.com> <20091022071748.GA17917@crane-desktop> <20091022174304.GO26149@tux1.beaverton.ibm.com> <20091023044451.GB1367@crane-desktop> <20091023170311.GC21723@tux1.beaverton.ibm.com> <20091025125353.55d3bfad@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091025125353.55d3bfad@hyperion.delvare>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 25, 2009 at 12:53:53PM +0100, Jean Delvare wrote:
> > +		else if (!probe_ibm_smbus_device(device))
> > +			acpi_add_id(device, ACPI_SMBUS_IBM_HID);
> 
> I am not responsible for the ACPI code, but... wouldn't it make sense
> to rename probe_ibm_smbus_device() to acpi_ibm_smbus_match() and have
> it follow the same convention as acpi_dock_match() and
> acpi_bay_match()? To make the code more consistent.

Sure.

> > +	{ACPI_SMBUS_IBM_HID, (kernel_ulong_t)&ibm_smbus_methods},
> 
> As both patches depend on each other and one is useless without the
> other, you might as well sequence them the other way around, so that
> you touch this line only once.

Will do.

> Other that these details, I like the patch. If this helps with ACPI
> resource conflicts, even better :)

It should. :)  I'll reroll the patch set shortly.

--D
