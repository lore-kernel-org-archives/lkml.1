Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbYFBPVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbYFBPVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYFBPVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:21:03 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:16010 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbYFBPVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:21:01 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 01/15] serial: when guessing, check only active resources, not options
Date: Mon, 2 Jun 2008 09:21:02 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224931.549456692@ldl.fc.hp.com> <4842FB89.6040802@keyaccess.nl>
In-Reply-To: <4842FB89.6040802@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806020921.04350.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 June 2008 01:42:01 pm Rene Herman wrote:
> We used to cry "modem" if the device _could_ be configured using a COM 
> address while after this change we'd only do so if it _was_ configured 
> using one.
> 
> My old analog modem for example had 5 dependent sets -- the first with 
> the regular COM port addresses (0x3f8, 0x2f8, 0x3e8, 0x2e8) and a 5th 
> one listing a port range of (IIRC, something like that at least) 0x100 
> to 0xff8.
> 
> So say I'd have a PC with the regular two onboard COM ports at COM1 and 
> COM2 (0x3f8 and 0x2f8) and an additional serial controller providing 
> COM3 and COM4 (0x3e8 and 0x2e8). My modem would then be configured to 
> use 0x100 and this code would no longer trigger while it did use to.

Ah, you're right.  That scenario hadn't occurred to me.  Let me see
if I can figure out a way to make that work again.

Bjorn
