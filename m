Return-Path: <linux-kernel-owner+w=401wt.eu-S1161322AbXBUT4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161322AbXBUT4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161157AbXBUT4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:56:04 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:40517 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161315AbXBUT4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:56:02 -0500
Date: Wed, 21 Feb 2007 08:46:56 -0500
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
Message-ID: <20070221134656.GD22464@csclub.uwaterloo.ca>
References: <45D85DA1.7090502@xs4all.nl> <20070218155445.GV7584@csclub.uwaterloo.ca> <45D87BA2.9020001@xs4all.nl> <20070218193901.GN7582@csclub.uwaterloo.ca> <45D9BDBF.8040405@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain> <45DA7643.4020305@xs4all.nl> <m33b505zez.fsf@maximus.localdomain> <20070220215103.GB22464@csclub.uwaterloo.ca> <m3ps844bfj.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3ps844bfj.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 01:11:12AM +0100, Krzysztof Halasa wrote:
> lsorense@csclub.uwaterloo.ca (Lennart Sorensen) writes:
> 
> > Via has a dual pci-ext card.  See EXT-PCI at
> > http://www.via.com.tw/en/products/mainboards/accessories.jsp
> 
> Right, and they say it's compatible with "EPIA mini-ITX family".
> That means the mappings I just outlined should apply to all of them.
> 
> BTW: any "universal" dual+ PCI riser card have to use a PCI bridge
> chip, and a bridge isn't a small 20 pin IC (I'd expect 144 pins or
> so). "Active" or "passive" - doesn't matter.
> -- 

Certainly.  The system I work with (which is not via based) has a PCI to
PCI bridge, which is 208pins (it supports 10 bus master loads behind it).
A cheap riser card that just does device number tricks will only work
on boards designed to use a riser card done that particular way.

--
Len Sorensen
