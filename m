Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbYBXMXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbYBXMXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 07:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYBXMXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 07:23:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48893 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYBXMXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 07:23:06 -0500
Date: Sun, 24 Feb 2008 13:23:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Reducing debuginfo size by removing unneeded includes
Message-ID: <20080224122335.GB13637@one.firstfloor.org>
References: <20080207230304.GA4352@ghostprotocols.net> <p73ir0mxvby.fsf@bingen.suse.de> <20080224075821.GA7781@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224075821.GA7781@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Just FYI, newer gcc does this in theory automatically when you specify 
> > 
> > -feliminate-unused-debug-types -feliminate-unused-debug-symbols
> google did not turn up anything useful.
> Do you have a poiter to where these are described?

info gcc

> 
> 
> > There is also -feliminate-dwarf2-dups, but it seems to even increase
> > obj dir size. Also -feliminate-dwarf2-dups seems to generate a lot of 
> 
> Google only turned up a patch from Mark Mitchell removing this
> in ~2001 timeframe.
> So again a pointer would be nice.
> 
> I use FC8:
> gcc --version
> gcc (GCC) 4.1.2 20070925 (Red Hat 4.1.2-33)
> 
> So this is far behind trunk that you use - but I have not had any
> real incentive to upgrade.


It's in my info pages for SUSE gcc 4.1. I didn't think it was
a SUSE extension though.


I also checked and all options are in gcc head and in gcc 4.3

> 
> I would like to have a remote understanding of the options before
> enabling them.

Right now they are not useful to enable because they don't save
file size and in some cases make it even worse. I checked with some gcc 
developers and they explained why that is so. gcc would need to be fixed first.

-Andi

