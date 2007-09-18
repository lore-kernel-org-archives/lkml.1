Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbXIRJxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbXIRJxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbXIRJxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:53:06 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:56341 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbXIRJxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:53:05 -0400
Date: Tue, 18 Sep 2007 13:53:05 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Robert Hancock <hancockr@shaw.ca>, Greg KH <gregkh@suse.de>,
       Matthew Wilcox <matthew@wil.cx>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
Message-ID: <20070918135305.A26491@jurassic.park.msu.ru>
References: <fa.13eJumylqINOxOaoEj9cthw0d0M@ifi.uio.no> <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no> <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no> <46EA00DA.6010704@shaw.ca> <20070914151401.A5586@jurassic.park.msu.ru> <46EA9B23.7030709@shaw.ca> <20070914192913.A6668@jurassic.park.msu.ru> <46EB1F16.8060209@shaw.ca> <20070916151355.A18508@jurassic.park.msu.ru> <1189992107.26772.4.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <1189992107.26772.4.camel@sli10-conroe.sh.intel.com>; from shaohua.li@intel.com on Mon, Sep 17, 2007 at 09:21:47AM +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 09:21:47AM +0800, Shaohua Li wrote:
> I can confirm this is an add-in graphics card. the bfd is 00:02.0, so
> it's not behind any AGP/PCI-E bridge.

AFAIKS, 00:02.0 is *integrated* controller. Can you check that "graphic
adapter priority" setting in BIOS is "PCI Express" and not "Internal VGA"?
In the latter case an add-on card might be turned completely off, so
it doesn't even show up in lspci output.

Ivan.
