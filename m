Return-Path: <linux-kernel-owner+w=401wt.eu-S1761715AbXEPLGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761715AbXEPLGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbXEPLGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:06:09 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:8930 "EHLO
	outbound1-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758695AbXEPLGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:06:07 -0400
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
From: "Peter Oruba" <peter.oruba@amd.com>
Organization: AMD
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] PCI-X/PCI-Express read control interfaces
Date: Wed, 16 May 2007 13:05:51 +0200
User-Agent: KMail/1.9.6
cc: gregkh@suse.de, cramerj@intel.com, john.ronciak@intel.com,
       jesse.brandeburg@intel.com, jeffrey.t.kirsher@intel.com,
       auke-jan.h.kok@intel.com, rolandd@cisco.com, halr@voltaire.com,
       linux-driver@qlogic.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>
References: <200705151350.28330.peter.oruba@amd.com>
 <20070515123721.1bfb02a3.akpm@linux-foundation.org>
In-Reply-To: <20070515123721.1bfb02a3.akpm@linux-foundation.org>
MIME-Version: 1.0
Message-ID: <200705161305.52398.peter.oruba@amd.com>
X-OriginalArrivalTime: 16 May 2007 11:05:10.0633 (UTC)
 FILETIME=[120B8D90:01C797AA]
X-WSS-ID: 6A543A1E20G2436357-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 15. Mai 2007 21:37:21 schrieb Andrew Morton:
> On Tue, 15 May 2007 13:50:27 +0200
>
> "Peter Oruba" <peter.oruba@amd.com> wrote:
> > This patch set introduces a PCI-X / PCI-Express read byte count control
> > interface. Instead of letting every driver to directly read/write to PCI
> > config space for that, an interface is provided. The interface functions
> > then can be used for quirks since some PCI bridges require that read byte
> > count values are set by the BIOS and left unchanged by device drivers.
>
> Some of the patches were wordwrapped, which I fixed.
>
> The way we would merge a feature like this is
>
> - get maintainers to review-and-ack the change
>
> - merge the core patch into Greg's PCI tree and later into
>   mainline.
>
> - Once the base infrastructure is in mainline, feed the per-driver
>   changes into the tree via the appropriate maintainers.
>
> This takes, umm, months and consumes quite a bit of my time.  I'm becoming
> inclined just to slam stuff like this straight in as you've proposed, but
> for now, let's play the game - I split the patches up appropriately.  I
> don't think there's any particular urgency behind this, is there?

I cannot tell how common AM8131 based systems in combination with one of these 
three devices actually are. However, this patch set is essential for those 
systems.


-- 
AMD Saxony Limited Liability Company & Co. KG
Operating System Research Center
Wilschdorfer Landstr. 101, 01109 Dresden, Germany
Register Court Dresden: HRA 4896
General Partner authorized to represent:
AMD Saxony LLC (Wilmington, Delaware, US)
General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


