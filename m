Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbXLDRdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbXLDRdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 12:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXLDRdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 12:33:36 -0500
Received: from styx.suse.cz ([82.119.242.94]:56527 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750831AbXLDRdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 12:33:36 -0500
From: David Sterba <dsterba@suse.cz>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [PATCH] ipwireless_cs driver for 4G PC Card
Date: Tue, 4 Dec 2007 18:33:27 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       akpm@linux-foundation.org, jeff@garzik.org, jkosina@suse.cz,
       jslaby@suse.cz, stephen@symmetric.co.nz, benm@symmetric.co.nz
References: <20071130125555.GA10977@ds.suse.cz> <alpine.LFD.0.9999.0711300759200.29812@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0711300759200.29812@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712041833.28743.dsterba@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> might it not make more sense to put all of that into a new
> subdirectory, say, /drivers/char/pcmcia/ipwireless_cs?  that way, it's
> more modular and it will keep that higher-level directory from
> potentially getting cluttered with even more drivers.  and it would
> let you drop the pointless "ipwireless_cs_" prefix from all of those
> files as well.

ok, will put it into ipwireless, and the _cs suffix will go away as suggested 
elsewhere. The filenames will then get very generic names, do you have 
suggestion for better names? There are many drivers in own directory and 
files inside have the same prefix. Maybe we can use names like ipw-hw.c, etc.

Dave
