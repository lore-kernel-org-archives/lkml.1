Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbXKMVhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbXKMVhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760467AbXKMVhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:37:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55353 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760949AbXKMVhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:37:12 -0500
Date: Tue, 13 Nov 2007 13:36:46 -0800
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113213646.GB4426@kroah.com>
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113183353.GE17785@parisc-linux.org> <20071113185122.GA22536@kroah.com> <20071113211509.GB19146@auslistsprd01.us.dell.com> <20071113213108.GB7541@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113213108.GB7541@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 02:31:08PM -0700, Alex Chiang wrote:
> * Matt Domsch <Matt_Domsch@dell.com>:
> > 
> > The only reported _SUN problems on Dell systems were on the
> > PE6800 and PE6850 systems, which we've fixed with an updated
> > BIOS several months ago.  IIRC the values weren't always unique
> > which kind of defeated the purpose.
> 
> FWIW, the ACPI 2.0 spec did not require uniqueness for _SUN.
> (although there is a strange table that refers to _SUN as the
> slot-unique ID (table 6-1 in spec v2.0b), the actual definition
> of _SUN does not mention uniqueness).

Does your code handle if these are not unique?

thanks,

greg k-h
