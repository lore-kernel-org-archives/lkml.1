Return-Path: <linux-kernel-owner+w=401wt.eu-S1761338AbYFKP5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338AbYFKP5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbYFKP5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:57:21 -0400
Received: from isilmar.linta.de ([213.133.102.198]:38463 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750963AbYFKP5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:57:20 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jun 2008 11:57:20 EDT
Date: Wed, 11 Jun 2008 09:20:29 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Komuro <komurojun-mbn@nifty.com>, Tejun Heo <htejun@gmail.com>,
       jgarzik@redhat.com, linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       linux-pcmcia <linux-pcmcia@lists.infradead.org>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: [KERNEL 2.6.26-rc4]  bugreport : pata_pcmcia with Sandisk
	Extreme III 8GB
Message-ID: <20080611072029.GB28692@comet.dominikbrodowski.net>
Mail-Followup-To: Komuro <komurojun-mbn@nifty.com>,
	Tejun Heo <htejun@gmail.com>, jgarzik@redhat.com,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pcmcia <linux-pcmcia@lists.infradead.org>,
	Kristoffer Ericson <kristoffer.ericson@gmail.com>
References: <20080528225049.9a134e0d.Kristoffer.Ericson@Gmail.com> <20080528222740.GB20893@isilmar.linta.de> <20080530135728.be02d3dc.Kristoffer.Ericson@Gmail.com> <20080607223716.7d142072.komurojun-mbn@nifty.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080607223716.7d142072.komurojun-mbn@nifty.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2008 at 10:37:16PM +0900, Komuro wrote:
> On Fri, 30 May 2008 13:57:28 +0200
> Kristoffer Ericson <kristoffer.ericson@gmail.com> wrote:
> 
> 
> > > > pcmcia: registering new device pcmcia1.0
> > > ...
> > > > pcmcia: registering new device pcmcia1.1
> > > > 1.1: GetNextTuple: No more items
> > > > pata_pcmcia: probe of 1.1 failed with error -12
> 
> This problem is introduced at kernel 2.6.26-rc4.
> 
> The kernel 2.6.26-rc3 does not have this problem.


git-diff drivers/pcmcia is empty for 2.6.26-rc3 to 2.6.26-rc4. Therefore,
it looks like something in the ata codepaths introduced this error? Tejun,
Jeff, any ideas? (original bugreport below)

Thanks,
	Dominik

> > > Hi,
> > > 
> > > > Ive added the id123 strings for a Sandisk Extreme III 8GB.
> > > > I get this when using pcmcia->CF adapter.
> > > 
> > > > pcmcia: registering new device pcmcia1.0
> > > ...
> > > > pcmcia: registering new device pcmcia1.1
> > > > 1.1: GetNextTuple: No more items
> > > > pata_pcmcia: probe of 1.1 failed with error -12
> > > 
> > > Is that a multifunction device? It seems to me that something is broken in
> > > the device CIS, for both drives seem to be exported already by device
> > > pcmcia1.0.
> > 
> > Its a simply pcmcia->CF adapter and the CF card is a simple storage one. I got it to work through USB-adapter after replacing my
> > broken one.
> > However it still doesnt work through the pcmcia->CF adapter.
> > 
> > Im not ruling out that its broken though.
> > 
> > > 
> > > Best,
> > > 	Dominik
