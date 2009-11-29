Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbZK2PLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbZK2PLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 10:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbZK2PLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 10:11:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36268 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbZK2PLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 10:11:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] change PCI nomenclature according to PCI-SIG
Date: Sun, 29 Nov 2009 16:12:15 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: Stefan Assmann <sassmann@redhat.com>, linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Krzysztof Halasa <khc@pm.waw.pl>, Don Dutile <ddutile@redhat.com>,
       kaneshige.kenji@jp.fujitsu.com
References: <4B110F79.8080405@redhat.com> <4B123A34.5090509@redhat.com> <4B126EEB.1040908@garzik.org>
In-Reply-To: <4B126EEB.1040908@garzik.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911291612.15648.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 November 2009, Jeff Garzik wrote:
> On 11/29/2009 04:09 AM, Stefan Assmann wrote:
> > On 28.11.2009 13:43, Jeff Garzik wrote:
> >> On 11/28/2009 06:54 AM, Stefan Assmann wrote:
> >>> From: Stefan Assmann<sassmann@redhat.com>
> >>>
> >>> Changing occurrences of variants of PCI-X and PCIe to the PCI-SIG
> >>> terms listed in the "Trademark and Logo Usage Guidelines".
> >>> http://www.pcisig.com/developers/procedures/logos/Trademark_and_Logo_Usage_Guidelines_updated_112206.pdf
> >>>
> >>> Additionally some renames of Gb/s to GT/s where appropriate, concerns
> >>> PCIe.
> >>>
> >>> This is a followup to the discussion at:
> >>> http://lkml.org/lkml/2009/10/14/107
> >>> Patch is based on 2.6.32-rc8.
> >>>
> >>> Signed-off-by: Stefan Assmann<sassmann@redhat.com>
> >>
> >> NAK, this clearly introduces bugs and changes sysfs output (ABI).
> >>
> >> Typically this type of change is pointless churn that creates far more
> >> problems than it "solves."
> >
> > Hi Jeff,
> >
> > I see you point in not liking this kind of change. What kind of cleanup
> > would be ok in your opinion?
> 
> Think about this from an engineering perspective.  This patch is driven 
> not by any real technical need, but more by marketing and trademark folks.
> 
> The absolute best case scenario for this patch is that nothing changes, 
> from an implementation and behavior standpoint.  The worst case, of 
> course, is that it introduces bugs (which it does).
> 
> You also incur the standard costs of any kernel change:  you've just 
> made the diff between, for example, a vendor kernel's foo_driver.c and 
> upstream's foo_driver.c a lot larger, and more difficult to discern 
> real, technical changes to the code.
> 
> Of course, we change the kernel every day -- but we also know that 
> change itself has cost, and a lot of code changes for cosmetic reasons 
> have the potential for greater negative costs, and fewer positive benefits.
> 
> Next, IMO, you don't have any idea how maintainers will react to this 
> patch, because you CC'd so few of them.  People who perform tree-wide 
> changes should take the time to CC __every__ relevant maintainer.  If 
> you are changing somebody's code, you should always let them know about 
> it, and give them an opportunity to review the change. 
> scripts/get_maintainer.pl can help with this.
> 
> So, while the PCI maintainer might agree with the nomenclature change, 
> he is not the most qualified person to state that your changes have no 
> effect on drivers/edac/ppc4xx_edac.c, for example.
> 
> Finally, split your patch up.  I would suggest starting with 100% 
> comment changes that are guaranteed with mathematical certainty to not 
> change the compiler-generated code at all.  That will make the remaining 
> changes much easier to review, if they are in separate patches from the 
> comment-only changes.

FWIW, I agree with everything said and I think it might be a good idea to
put something like this into Documentation/ for people wanting to make similar
changes in future.

Thanks,
Rafael
