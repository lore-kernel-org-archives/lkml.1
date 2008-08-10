Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbYHJMYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbYHJMYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 08:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbYHJMYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 08:24:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49323 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbYHJMYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 08:24:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Query: should 'Marvell SATA support' depend on PCI?
Date: Sun, 10 Aug 2008 14:26:39 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org
References: <vg3t941ebudmtb8afj82thuldug82ak1fs@4ax.com> <200808101408.11393.rjw@sisk.pl> <20080810125432.3504a7fa@lxorguk.ukuu.org.uk>
In-Reply-To: <20080810125432.3504a7fa@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808101426.39778.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 10 of August 2008, Alan Cox wrote:
> > > doesn't have 'depends on PCI && EXPERIMENTAL' like other drivers around 
> > > it, this is okay or should it also depend on PCI?
> > 
> > Well, I think so.  It obviously depends on PCI.
> 
> Obviously ? Try looking a bit harder
> 
> /**
>  *      mv_platform_probe - handle a positive probe of an soc Marvell
>  *      host
>  *      @pdev: platform device found
>  *
>  *      LOCKING:
>  *      Inherited from caller.
>  */
> static int mv_platform_probe(struct platform_device *pdev)

Sorry, I didn't notice the '#ifdef CONFIG_PCI' in there.

Rafael
