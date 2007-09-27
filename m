Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbXI0PkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbXI0PkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004AbXI0Pjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:39:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58840 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbXI0Pjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:39:53 -0400
Date: Thu, 27 Sep 2007 08:34:38 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <gregkh@suse.de>, Brice Goglin <Brice.Goglin@ens-lyon.org>,
       torvalds@osdl.org, Andrew Morton <akpm@osdl.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: State of the Linux PCI Subsystem for 2.6.23-rc8
Message-ID: <20070927153438.GC30419@kroah.com>
References: <20070926210010.GC1734@kroah.com> <46FAD1EA.6090504@ens-lyon.org> <20070926213931.GA24049@suse.de> <46FB5A3B.4020801@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FB5A3B.4020801@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 03:22:35AM -0400, Jeff Garzik wrote:
> Greg KH wrote:
>> On Wed, Sep 26, 2007 at 11:40:58PM +0200, Brice Goglin wrote:
>>> Greg KH wrote:
>>>> Here's a summary of the current state of the Linux PCI subsystem, as of
>>>> 2.6.23-rc8.
>>>>
>>>> If the information in here is incorrect, or anyone knows of any
>>>> outstanding issues not listed here, please let me know.
>>>>
>>>> List of outstanding regressions from 2.6.22:
>>>> 	- none known.
>>>>
>>>> List of outstanding regressions from older kernel versions:
>>>> 	- none known.
>>>>   
>>> What about http://marc.info/?l=linux-pci&m=119072400008538&w=2 ?
>> That's not a regression, right?  Tt's probably never worked for that
>> kind of box :)
>> I think the pci bus patches that are pending from Jeff Garzik should fix
>> up these issues.  They are in one of his trees, and in the -mm release,
>> if you are able to test those.
>
> jgarzik/misc-2.6.git#pciseg has my only outstanding PCI stuff, which is a 
> small x86[-64] PCI domain support patch.  Mostly unrelated to the thread at 
> hand, alas, even though it was touching that area.
>
> I need to a few changes required by Andi, who made several good points, 
> then the PCI domains thing should be ready for upstream.  I don't care much 
> who merges it, you, Andi or me.

I'll take it, as I guess it should go through me, Andi is going to have
enough merge issues for 2.6.24 :)

I'll add them to my tree later today.

> As I recall, some NUMA folks hacked in my damage (storing numa node in 
> x86's new struct pci_sysdata), noted and fixed additional fallout, and 
> added their own damage for good measure :)

Yeah, I don't really trust all of the pci numa things as it keeps
blowing up in odd ways, and we seem to be doing a lot of extra work for
the 2 NUMA-CUBE users in the whole world...

thanks,

greg k-h
