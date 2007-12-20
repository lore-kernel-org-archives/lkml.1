Return-Path: <linux-kernel-owner+w=401wt.eu-S1759121AbXLTQ5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121AbXLTQ5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764904AbXLTQ5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:57:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57958 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760386AbXLTQ5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:57:30 -0500
Date: Thu, 20 Dec 2007 08:48:19 -0800
From: Greg KH <greg@kroah.com>
To: Tony Camuso <tcamuso@redhat.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 1/5]PCI: x86 MMCONFIG: introduce
	PCI_USING_MMCONF]
Message-ID: <20071220164819.GA15496@kroah.com>
References: <476A5EAF.6020008@redhat.com> <476A79D4.4090002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476A79D4.4090002@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 09:19:00AM -0500, Tony Camuso wrote:
> Tony Camuso wrote:
>
>> Greg KH wrote:
>>> On Wed, Dec 19, 2007 at 05:17:51PM -0500, tcamuso@redhat.com wrote:
>>>>  +extern struct pci_ops pci_legacy_ops;     /* direct.c */
>>>
>>> This isn't needed in this patch at all, and might make the compiler
>>> confused if you were to build with only this patch present :(
>>>
>>> thanks,
>>>
>>> greg k-h
>> Yes, of course. I missed that. Thank you.
> I take that back.
>
> This struct must be declared extern because it is referenced in
> arch/x86/pci/common.c by pcibios_fix_bus_scan_quirk()

Sure, but you do not reference it in this patch, right?  So it's not
needed until you actually use it, so just include it in the patch that
you are needing it in.

thanks,

greg k-h
