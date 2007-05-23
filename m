Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbXEWWzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbXEWWzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbXEWWzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:55:31 -0400
Received: from outbound-mail-32.bluehost.com ([69.89.18.152]:58792 "HELO
	outbound-mail-32.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755898AbXEWWza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:55:30 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Wed, 23 May 2007 15:55:07 -0700
User-Agent: KMail/1.9.6
Cc: Olivier Galibert <galibert@pobox.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <20070523222443.GA39776@dspnet.fr.eu.org> <alpine.LFD.0.98.0705231536510.3890@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705231536510.3890@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231555.07683.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 23, 2007 3:48 pm Linus Torvalds wrote:
> On Thu, 24 May 2007, Olivier Galibert wrote:
> > Isn't that a mac-intel instant killer?  AFAIK they don't have
> > type1, period.
>
> mac-intel are totally standard Intel chipsets. They have all of
> conf1/conf2/mmconfig afaik.
>
> I just happily booted my mac-mini with "pci=nommconf", nothing bad
> happened, and the kernel says
>
> 	PCI: Using configuration type 1
>
> and I don't think you even _can_ disable conf1 type accesses: they
> are deep in the Intel chipsets.

After I sent my last message I realized the same thing... though I 
occasionally hear people talk about removing it (I seriously doubt that 
will ever happen).  I don't even think there's a way to disable type 1 
config access on Intel chipsets...

So the last patch is ok then, as long as we can find mmconfig space in 
the first place, but that's a separate problem for another set of 
patches (ones that seem to be working fairly well now btw).

Jesse

