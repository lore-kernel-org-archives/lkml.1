Return-Path: <linux-kernel-owner+w=401wt.eu-S1161169AbXCBHTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161169AbXCBHTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 02:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161235AbXCBHTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 02:19:20 -0500
Received: from ellpspace.math.ualberta.ca ([129.128.207.67]:58246 "EHLO
	ellpspace.math.ualberta.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161141AbXCBHTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 02:19:19 -0500
X-Greylist: delayed 2641 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2007 02:19:19 EST
Date: Thu, 1 Mar 2007 23:35:07 -0700
From: Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Cable detection fixes
Message-ID: <20070302063507.GA8345@ellpspace.math.ualberta.ca>
Reply-To: michal@harddata.com
References: <20070301173003.5d5ab4a6@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0703011723270.12485@woody.linux-foundation.org> <45E77EDD.3010205@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E77EDD.3010205@garzik.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 08:33:17PM -0500, Jeff Garzik wrote:
> 
> That little change, buried in the middle of Alan's patch, changes the 
> probing order for a /lot/ of devices, possibly millions, when you 
> consider that it changes behavior of ata_piix (Intel SATA) as well as 
> all the not-yet-default PATA controllers.

Hm, I got recently hands on a hardware where 2.6.21-rc1 based
kernels from Fedora rawhide simply do not boot as there is no
way to get to disks.  I would not mind some change in behavior
although so far I can boot at least some earlier kernels.

This looks like ATIIXP issue and details are here:
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229621
Changelogs for kernels in question have this:

* Wed Feb 21 2007 Dave Jones <davej@redhat.com>
- 2.6.21-rc1

   Michal
