Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbXIUKAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbXIUKAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 06:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbXIUKAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 06:00:12 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60320 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167AbXIUKAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 06:00:10 -0400
Date: Fri, 21 Sep 2007 12:01:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Gregory 'GaLi' Cavelier" <gali@cleia.org>
Cc: kkeil@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ISDN: Change pci_find_device() calls to pci_get_device()
Message-ID: <20070921100133.GA18631@uranus.ravnborg.org>
References: <20070921105508.d1a6a369.gali@cleia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921105508.d1a6a369.gali@cleia.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory.

On Fri, Sep 21, 2007 at 10:55:08AM +0200, Gregory 'GaLi' Cavelier wrote:
> 
> The following patch removes the obsolete pci_find_device() calls and replaces them with pci_get_device() for all ISDN drivers.
> 
> Compilation is fine but I haven't tested it since I don't own a ISDN card. Should be fine since the return value and parameters of pci_find_device() and pci_get_device() are the same.
> 
> The is my first patch so be nice to me  :)
Jeff Garzik has been doing a lot of work lately on the ISDN subsystem.
So please check his work to avoid doing the same work twice.

Of benefit for everyone would be a throughfull review of the changes
Jeff made. It is a nice learning expericen if not anything else.

You can find the ISDN change in one of the branches in Jeff's
public treee's at git.kernel.org.
Try also to seach the lkml archives for his work.

All that said I have not chacked if he addressed this specific cleanup.

	Sam
