Return-Path: <linux-kernel-owner+w=401wt.eu-S1765912AbYBAAvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765912AbYBAAvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 19:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965123AbYBAAui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 19:50:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46409 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965118AbYBAAuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:50:37 -0500
Date: Fri, 1 Feb 2008 11:50:13 +1100 (EST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@www.l.google.com
To: Robert Hancock <hancockr@shaw.ca>
cc: Andrew Morton <akpm@linux-foundation.org>, avuton@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, bjorn.helgaas@hp.com,
       trenn@suse.de, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0
 sound card
In-Reply-To: <47A2644B.4000905@shaw.ca>
Message-ID: <alpine.LFD.1.00.0802011149160.3198@www.l.google.com>
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no> <479CCAAD.4080706@shaw.ca> <20080131145820.44171af2.akpm@linux-foundation.org> <47A2644B.4000905@shaw.ca>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 Jan 2008, Robert Hancock wrote:
> 
> I think so. There was one objection that it introduced a dependency on pnpacpi
> loading after PCI bus enumeration, though.
> 
> Linus also suggested that pnpacpi could be marking the resources as "present
> but unused" so that drivers can request those regions but we still prevent
> dynamically assigning resources into them.

I _think_ that's what ACPI used to do before switching over to the PnPACPI 
thing, so I do think that "present but not reserved" approach is not just 
the right one, but also the (historically) tested one.

		Linus
