Return-Path: <linux-kernel-owner+w=401wt.eu-S1760222AbYBNTnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbYBNTnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614AbYBNTnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:43:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38001 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753708AbYBNTnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:43:16 -0500
Date: Thu, 14 Feb 2008 11:42:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, avuton@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, trenn@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0
 sound card
In-Reply-To: <200802141151.40396.bjorn.helgaas@hp.com>
Message-ID: <alpine.LFD.1.00.0802141141470.6110@woody.linux-foundation.org>
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no> <alpine.LFD.1.00.0802051013110.9374@woody.linux-foundation.org> <200802051312.47074.bjorn.helgaas@hp.com> <200802141151.40396.bjorn.helgaas@hp.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Feb 2008, Bjorn Helgaas wrote:
> 
> Sorry for the delay.  I did work on this, but I don't see how this
> can work.  pcibios_init() marks its reservations as not busy, so the
> subsequent PNP request doesn't fail, even if it clashes.

It *shouldn't* fail.

Things should fail only when two different drivers have requested the same 
region. NOT when something tells the system that a region _exists_.

Two different things.

		Linus
