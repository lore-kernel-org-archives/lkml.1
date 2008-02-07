Return-Path: <linux-kernel-owner+w=401wt.eu-S1756443AbYBGIUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbYBGIUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 03:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbYBGIUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 03:20:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136AbYBGIUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:20:43 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SuSE Linux Products GmbH
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [PATCH v2] mmc: extend ricoh_mmc to support Ricoh RL5c476
Date: Thu, 7 Feb 2008 09:20:38 +0100
User-Agent: KMail/1.9.5
Cc: Philip Langdale <philipl@overt.org>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, Andrew de Quincey <adq_dvb@lidskialf.net>
References: <200801311838.24743.fseidel@suse.de> <200802041925.43081.fseidel@suse.de> <20080207090834.3c6fde7d@poseidon.drzeus.cx>
In-Reply-To: <20080207090834.3c6fde7d@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802070920.39120.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 07 February 2008 09:08, Pierre Ossman wrote:
> On Mon, 4 Feb 2008 19:25:42 +0100
> Frank Seidel <fseidel@suse.de> wrote:
> > Signed-off-by: Frank Seidel <fseidel@suse.de>
> 
> I see you've guys have kept yourself busy in my absence. :)

Yes, we really did :)

> As for the patch, it looks ok although I'm not really a fan of more
> voodoo constants that noone knows what they mean. Could you add some
> comments explaining some of them at least?  

I also don't like that voodoo, but as long as we don't have more information
or let alone specs.. well, i really wish i could provide more than
the already IMHO obvious sequence.. voodoo-adress and value to make config
bit writeable, set voodo-bit and cleanup again.

> > +	if (fw_dev->device == PCI_DEVICE_ID_RICOH_RL5C476) {
> 
> *snip*
> 
> > +	} else {
> > +		/* via R5C832 */
> 
> Wouldn't it be prudent to have a check that this is indeed a R5C832,
> and a failure mode if it's none of the two known devices? 

Also thought about that, but as far as i can see this cannot happen since
we only probe for those two devices and deny to continue if anything else
/those two were not found in the beginning.

Thanks,
Frank
