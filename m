Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbYGVRSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbYGVRSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYGVRSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:18:06 -0400
Received: from ns.suse.de ([195.135.220.2]:45096 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbYGVRSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:18:05 -0400
Date: Tue, 22 Jul 2008 10:16:06 -0700
From: Greg KH <gregkh@suse.de>
To: "Altobelli, David" <david.altobelli@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 75/79] HP iLO driver
Message-ID: <20080722171606.GA20669@suse.de>
References: <20080722051805.GA17373@suse.de> <1216703983-21448-75-git-send-email-gregkh@suse.de> <CF70AA892F109448AEA269483B3A983903C30E04F2@G1W1215.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CF70AA892F109448AEA269483B3A983903C30E04F2@G1W1215.americas.hpqcorp.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 05:11:16PM +0000, Altobelli, David wrote:
> Greg Kroah-Hartman wrote:
> > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > index 1921b8d..ce67d97 100644
> > --- a/drivers/misc/Kconfig
> > +++ b/drivers/misc/Kconfig
> > @@ -420,4 +420,17 @@ config SGI_XP
> >           this feature will allow for direct communication between SSIs
> >           based on a network adapter and DMA messaging.
> >
> > +config HP_ILO
> > +       tristate "Channel interface driver for HP iLO/iLO2 processor"
> > +       default n
> 
> Heiko Carstens submitted a Kconfig "depend on PCI" patch to linux-next,
> and that should be included with this series.  His mail is below.
> Outlook might well mangle the diff, but that's my fault, not his.

Thanks, sorry I missed that one, I'll add it to my queue for the next
patch series to go to Linus.

greg k-h
