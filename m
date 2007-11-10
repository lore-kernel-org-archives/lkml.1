Return-Path: <linux-kernel-owner+w=401wt.eu-S1763933AbXKJDzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763933AbXKJDzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 22:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759779AbXKJDzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 22:55:38 -0500
Received: from THUNK.ORG ([69.25.196.29]:46338 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758064AbXKJDzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 22:55:37 -0500
Date: Fri, 9 Nov 2007 22:54:24 -0500
From: Theodore Tso <tytso@mit.edu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mark Lord <liml@rtr.ca>,
       Riki Oktarianto <rkoktarianto@gmail.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
Message-ID: <20071110035424.GB28975@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Mark Lord <liml@rtr.ca>, Riki Oktarianto <rkoktarianto@gmail.com>,
	linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
	linux-ide@vger.kernel.org
References: <20071109020235.GA2031@ceren> <20071109023129.GA25581@havoc.gtf.org> <4733D421.7000505@rtr.ca> <20071109034622.GB25581@havoc.gtf.org> <20071109120425.543971bf@the-village.bc.nu> <47351FE1.4000001@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47351FE1.4000001@garzik.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 10:05:05PM -0500, Jeff Garzik wrote:
> By forcing AHCI, your PATA devices will be inaccessible, in a common 
> configuration.  It also means shuffling users from one driver to another, 
> which induces breakage.
>
> I was speaking wishfully.  Real life intrudes, alas.

Not even as boot-time option?  I'm curious whether it might allow me
to use AHCI mode on a T60p laptop; right now I can't because in AHCI
mode the Ultrabay hard drive device becomes invisible to Linux
(although not to Windows, interestingly).  I'm currently travelling
and I don't carry the T60 around anymore, so I can't do the experiment
right this moment, but given that this would allow the T60 to take
advantage of ALPM if this works, it would be awfully tempting....

   	   	       	  	- Ted
