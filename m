Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbZBTKV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbZBTKV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 05:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZBTKVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 05:21:47 -0500
Received: from smtp.flash.net.br ([201.46.240.48]:47595 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbZBTKVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 05:21:46 -0500
Date: Fri, 20 Feb 2009 07:21:39 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Greg KH <greg@kroah.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, rbrito@ime.usp.br
Subject: Re: Stack trace with kernel 2.6.29-rc2
Message-ID: <20090220102139.GA22225@ime.usp.br>
References: <20090202192823.GA3181@ime.usp.br> <alpine.LRH.1.10.0902031345410.22097@twin.jikos.cz> <20090203173701.GA30687@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090203173701.GA30687@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Greg. Hi, Jiri. Hi, others.

Sorry for not replying earlier, but I had some personal problems (real
life getting into the way).

On Feb 03 2009, Greg KH wrote:
> On Tue, Feb 03, 2009 at 01:46:06PM +0100, Jiri Kosina wrote:
> > 
> > On Mon, 2 Feb 2009, Rogério Brito wrote:
> > > [64025.510204] ------------[ cut here ]------------
> > > [64025.510211] WARNING: at drivers/usb/storage/transport.c:584 last_sector_hacks+0xfd/0x155 [usb_storage]()
> > > [64025.510214] Hardware name:  
> 
> I think this message happened when it was plugged in, not removed.

Yes, exactly. That was exactly the case.

> It's a known issue and will be addressed in the next -rc.

I can confirm that the problem does not exist anymore with -rc5 (which
is the one that I'm using right now).


Thanks,

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
