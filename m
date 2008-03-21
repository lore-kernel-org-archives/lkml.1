Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbYCUNUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbYCUNUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbYCUNUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:20:07 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:39135 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbYCUNUG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:20:06 -0400
X-Greylist: delayed 741 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Mar 2008 09:20:06 EDT
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [ugly patch] Save .15W-.5W by AHCI powersaving
Date: Fri, 21 Mar 2008 08:49:56 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jeff Garzik <jeff@garzik.org>, Mark Lord <liml@rtr.ca>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
References: <20080225134558.GA1611@elf.ucw.cz> <47C34081.5090205@rtr.ca> <47C34472.3090706@garzik.org>
In-Reply-To: <47C34472.3090706@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803210849.58035.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 25. Februar 2008 23:42:58 schrieb Jeff Garzik:
> > This is cool enough that we really ought to do a hardware-independent
> > version, so that all SATA interfaces could benefit.  Especially ata_piix,
> > but others too.
> 
> BTW we can also save power by allowing the user to choose to disable 
> hotplugging support.  Then we can power down PHYs that are not in use.

Can't we power them up periodically to check for new hardware?

	Regards
		Oliver

