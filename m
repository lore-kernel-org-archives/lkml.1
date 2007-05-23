Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbXEWWcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbXEWWcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbXEWWcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:32:03 -0400
Received: from outbound-mail-76.bluehost.com ([69.89.22.25]:47609 "HELO
	outbound-mail-76.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755293AbXEWWcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:32:01 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Olivier Galibert <galibert@pobox.com>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Wed, 23 May 2007 15:31:47 -0700
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <200705231420.26622.jbarnes@virtuousgeek.org> <20070523222443.GA39776@dspnet.fr.eu.org>
In-Reply-To: <20070523222443.GA39776@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231531.47927.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 23, 2007 3:24 pm Olivier Galibert wrote:
> On Wed, May 23, 2007 at 02:20:23PM -0700, Jesse Barnes wrote:
> > On Wednesday, May 23, 2007 1:56 pm Linus Torvalds wrote:
> > > Ehh. Even for PCIe, why not use the normal accesses for the first
> > > 256 bytes? Problem solved.
> >
> > Ok, this patch also works.  We still need to enable mmconfig space
> > for PCIe and extended config space, but we can continue to use type
> > 1 accesses for legacy PCI config space cycles to avoid decode
> > trouble with mmconfig based BAR sizing.
>
> Isn't that a mac-intel instant killer?  AFAIK they don't have type1,
> period.

Yuck.  I'll have to add a check for type 1 then... but that also means 
Macs will probably want the decode disable stuff I posted earlier.

Jesse
