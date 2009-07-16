Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbZGPAJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbZGPAJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 20:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbZGPAJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 20:09:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:35048 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594AbZGPAJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 20:09:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,407,1243839600"; 
   d="scan'208";a="430608227"
Subject: Re: Why do we probe option roms at 2K boundaries?
From: Dan Williams <dan.j.williams@intel.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <9e4733910907151613n777261e5k3e3c1cd646c7922a@mail.gmail.com>
References: <1247698965.3989.1.camel@dwillia2-linux.ch.intel.com>
	 <20090716001016.489fa970@lxorguk.ukuu.org.uk>
	 <9e4733910907151613n777261e5k3e3c1cd646c7922a@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 17:08:53 -0700
Message-Id: <1247702933.4215.4.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 16:13 -0700, Jon Smirl wrote:
> On Wed, Jul 15, 2009 at 7:10 PM, Alan Cox<alan@lxorguk.ukuu.org.uk> wrote:
> >> interrogating a data structure stored in option-rom memory.  My initial
> >> implementation involved blindly scanning from c0000 to f0000 in 512 byte
> >> increments.  Neil and others pointed out that this may not be a safe
> >
> > It isn't safe. If you hit certain ISA devices your system will drop dead.
> > OTOH I doubt anyone has an intel matrix raid controller and a WD80x3 on
> > the same box ;)
> 
> Random link from google, slide 21
> http://download.microsoft.com/download/9/8/f/98f3fe47-dfc3-4e74-92a3-088782200fe7/TWAR05005_WinHEC05.ppt
> 
> PCI 3.0+ allows 512b alignment, but you must first make sure you are
> on a PCI 3.0+ system.

Thanks, I believe this may be the missing difference between my test
system and Hans'.


