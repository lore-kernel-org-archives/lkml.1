Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbYIZVk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbYIZVk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYIZVkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:40:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35131 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbYIZVkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:40:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: D945GCLF  intel atom board & r8169 ethernet broken in linux-2.6.27-rc5??
Date: Fri, 26 Sep 2008 23:45:46 +0200
User-Agent: KMail/1.9.9
Cc: John Gumb <john.gumb@tandberg.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Kok, Auke" <auke-jan.h.kok@intel.com>
References: <9F6ACAE02B6DD040A1E259977622CFDB03F5BCCB@oslexcp1.eu.tandberg.int> <20080924201903.GA10546@electric-eye.fr.zoreil.com>
In-Reply-To: <20080924201903.GA10546@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809262345.47373.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 24 of September 2008, Francois Romieu wrote:
> John Gumb <john.gumb@tandberg.com> :
> [...]
> > With linux-2.6.27-rc5, "ifconfig eth0" just hangs. lspci -vvx reports,
> > after loading the driver,
> > 
> > > 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E
> > PCI Express Fast Ethernet controller (rev ff) (prog-if ff)
> > >       !!! Unknown header type 7f
> > 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  
> > 
> > Before I load the driver lspci -vvx looks OK.
> 
> It is probably the driver's responsibility then.
> 
> > I do not have (much) time to look into this any further but hopefully
> > this might help someone.
> 
> Can you try patches #0001 .. #0008 at
> http://userweb.kernel.org/~romieu/r8169/2.6.27-rc6/20080913/ ?

FWIW, these patches make the Ethernet card in the MSI Wind I've been recently
testing work much much more reliably. :-)

Thanks,
Rafael
