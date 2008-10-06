Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbYJFQuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbYJFQuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 12:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYJFQuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 12:50:14 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:13856 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbYJFQuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:50:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hV+yj66Nux5IZT6B6wLwQSGuLqJR93jvye5tJABI2Auyw50o30aSb6Jjgf/KhKpjLA
         F9HMbifICnegqJmr0p6OTE06/mkGwm1Ui/1KjjIZIpAy+a58l/pa5RDcE2csIQCRCkfS
         u1d9pDeO5I+OFEop59D5XBnN1VSnGwy094HBg=
Date: Mon, 6 Oct 2008 20:50:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrey Batyiev <batyiev@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: APIC misconfiguration
Message-ID: <20081006165007.GA7317@localhost>
References: <200810061923.09076.batyiev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810061923.09076.batyiev@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrey Batyiev - Mon, Oct 06, 2008 at 07:23:08PM +0300]
| Hello everyone
| 
| I'm trying to create touchscreen driver for Wibrain UMPC. I found
| out that device doesn't emit interrupts until I switch polarity
| field in IO_APIC_route_entry. To do this, I need to export
| ioapic_read_entry and ioapic_write_entry symbols from
| arch/x86/kernel/io_apic_{32,64}.c
| Is there any other (better) way to do this?
| 
| Thanks,
|    Andrey
| 

Hi Andrey,

actually it's not a bug of APIC itself but rather misconfigured
device I think. Not sure thru which bus it does work (pci
i suppose) but I think you better are to fix it on more higher
level like in config space of this device. PCI guys could tell
you more about this area I believe.

		- Cyrill -
