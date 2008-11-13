Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYKMUwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYKMUwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 15:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYKMUvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 15:51:55 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:36668 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbYKMUvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 15:51:54 -0500
Date: Thu, 13 Nov 2008 20:51:52 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] acpiphp: Identify more removable slots
Message-ID: <20081113205152.GA11577@srcf.ucam.org>
References: <20081113202739.GA11107@srcf.ucam.org> <20081113204859.GC1617@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113204859.GC1617@parisc-linux.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 01:48:59PM -0700, Matthew Wilcox wrote:

> Why not:
> 
>  	status = acpi_get_handle(handle, "_EJ0", &tmp);
> 	if (ACPI_SUCCESS(status))
> 		return 1;
> 
> 	status = acpi_get_handle(handle, "_RMV", &tmp);
> 	if (ACPI_SUCCESS(status))
> 		return 1;
> 
> 	return 0;

Oh, yes, that'd work.

> > +	if (ACPI_SUCCESS(status) || is_dock_device(handle))
> > +		valid = 1;
> > +
> > +	if (!valid)
> >  		return AE_OK;
> 
> This looks like almost the same code as above.  New helper function?

It's not quite the same, but yes, I'll see if it can be reduced.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
