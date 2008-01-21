Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbYAUU5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbYAUU5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 15:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYAUU5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 15:57:25 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:53321 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbYAUU5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 15:57:23 -0500
Date: Mon, 21 Jan 2008 22:56:01 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>
Subject: Re: kbuild: improved Section mismatch detection
Message-ID: <20080121205601.GA9395@does.not.exist>
References: <20080120200527.GA23852@uranus.ravnborg.org> <20080120222754.GK8669@does.not.exist> <20080121203117.GA752@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080121203117.GA752@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 09:31:17PM +0100, Sam Ravnborg wrote:
> On Mon, Jan 21, 2008 at 12:27:54AM +0200, Adrian Bunk wrote:
> > On Sun, Jan 20, 2008 at 09:05:27PM +0100, Sam Ravnborg wrote:
> > >...
> > > Adrian reminded us that KCFLAGS=-fno-inline told
> > > another story with more than 100 Section mismatch
> > > warnings on 64 bit x86 with an allyesconfig build.
> > >...
> > 
> > Not -fno-inline but -fno-inline-functions-called-once
> > (completely different option).
> 
> Do you know when gcc started to support
> -fno-inline-functions-called-once?
> 
> I do not have anything older than 3.4.5 build here.
> 
> I should have a gcc 3.2 (Documentation/Changes)
> but no at the moment.

The inline-functions-called-once optimization is only available with 
unit-at-a-time, and the -fno-inline-functions-called-once option is 
therefore present since gcc 3.4.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

