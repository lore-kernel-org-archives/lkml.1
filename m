Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbXEWVio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbXEWVio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756278AbXEWVig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:38:36 -0400
Received: from outbound-mail-75.bluehost.com ([69.89.20.10]:48213 "HELO
	outbound-mail-75.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755240AbXEWVig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:38:36 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Wed, 23 May 2007 14:37:58 -0700
User-Agent: KMail/1.9.6
Cc: Jeff Garzik <jgarzik@pobox.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>,
       Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <4654AD91.1030808@pobox.com> <20070523223513.7dbb89f4@the-village.bc.nu>
In-Reply-To: <20070523223513.7dbb89f4@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231438.03910.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 23, 2007 2:35 pm Alan Cox wrote:
> > One of the reasons why hardware vendors want to move away from
> > traditional accesses is to be able to use the larger config space
> > in PCI-Express, rather than being locked into the 256-byte legacy
> > PCI config space.
>
> Mostly for treacherous computing extensions where subsets of the
> config space can only be accessed by signed machines blessed by your
> favourite movie company and video card vendor...

I hate "trusted" platform garbage as much as the next guy 
(where "trusted" means the actual user can't trust it, just the 
seller), but I think there are legitimate uses of extended space as 
well, PCIe AER uses it iirc, so don't dismiss it on those grounds. :)

Jesse
