Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbZAKJqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbZAKJqn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 04:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZAKJqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 04:46:35 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:57361 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbZAKJqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 04:46:33 -0500
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jan 2009 04:46:33 EST
Date: Sun, 11 Jan 2009 10:41:11 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Enrik Berkhan <Enrik.Berkhan@ge.com>, David Vrabel <david.vrabel@csr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Reference counting of MMC host driver modules
Message-ID: <20090111104111.5a0f00e1@mjolnir.drzeus.cx>
In-Reply-To: <49686F0C.7030807@s5r6.in-berlin.de>
References: <49678443.8040909@ge.com>
	<49679570.3070403@csr.com>
	<20090109200024.GA14754@ngeserver2.localdomain>
	<49686F0C.7030807@s5r6.in-berlin.de>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009 10:49:00 +0100
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> 
> So, if somebody asked me to copy my ieee1394/sbp2 safeguard into
> firewire/fw-sbp2, I would reject that on the grounds that killing the
> connection to the FireWire disk is the *expected result* of
> # modprobe -r firewire-ohci

I have to agree with Stefan's reasoning here. The reference counting is
about protecting kernel integrity, not about saving the user's foot.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
