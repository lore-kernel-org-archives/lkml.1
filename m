Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbYDHVvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbYDHVvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYDHVvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:51:41 -0400
Received: from main.gmane.org ([80.91.229.2]:56231 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbYDHVvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:51:40 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andres Salomon <dilinger@queued.net>
Subject: Re: [patch 2/15] fs/logfs/logfs_abi.h
Date: Tue, 8 Apr 2008 17:52:59 -0400
Message-ID: <20080408175259.6f5d3d2c@ephemeral>
References: <20080401181308.512473173@logfs.org>
	<20080401181332.853833002@logfs.org>
	<200804080224.18014.arnd@arndb.de>
	<20080408093946.GA31266@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: wireless.queued.net
X-Newsreader: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Cc: linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008 11:39:46 +0200
Jörn Engel <joern@logfs.org> wrote:

> On Tue, 8 April 2008 02:24:17 +0200, Arnd Bergmann wrote:
> > 
> > Great to see a new version finally posted again!
> 
> As Artem already noted, the transition to write-back caching was a
> significant change and initially caused a huge drop in quality.  Took a
> while.
> 
> > On Tuesday 01 April 2008, joern@logfs.org wrote:
> > > --- /dev/null	2008-04-02 16:29:12.813336657 +0200
> > > +++ linux-2.6.24logfs/fs/logfs/logfs_abi.h	2008-04-01 21:02:34.980239877 +0200
> > > @@ -0,0 +1,523 @@
> > > +/*
> > > + * fs/logfs/logfs.h
> > 
> > The comment doesn't match the file name, and the file name doesn't
> > match the purpose -- you are not defining an "application" binary
> > interface but rather the medium format, with the small exception
> > of the chattr flags.
> 
> Now it matches the file name.  If you have a better name than "abi",
> I'll use that.
> 
> > > +#ifndef fs_logfs_logfs_abi_h
> > > +#define fs_logfs_logfs_abi_h
> > 
> > Everyone else uses capital letters for these.
> 
> Changed.
> 

Hm, logfs.patch.771 contains lowercase.  Do you have your latest
patch set somewhere online?  Alternatively, would you mind pushing
your git tree somewhere public?


