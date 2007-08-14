Return-Path: <linux-kernel-owner+w=401wt.eu-S934942AbXHNT34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934942AbXHNT34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 15:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbXHNT3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 15:29:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418AbXHNT3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 15:29:44 -0400
Date: Tue, 14 Aug 2007 22:23:51 +0200
From: Andi Kleen <ak@suse.de>
To: Andy Isaacson <adi@hexapodia.org>
Cc: Andi Kleen <ak@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@skynet.ie>,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones pointer
Message-ID: <20070814202350.GT3406@bingen.suse.de>
References: <20070813225841.GG3406@bingen.suse.de> <Pine.LNX.4.64.0708131506030.28502@schroedinger.engr.sgi.com> <20070813230801.GH3406@bingen.suse.de> <Pine.LNX.4.64.0708131536340.29946@schroedinger.engr.sgi.com> <20070813234322.GJ3406@bingen.suse.de> <Pine.LNX.4.64.0708131553050.30626@schroedinger.engr.sgi.com> <20070814000041.GL3406@bingen.suse.de> <20070814002223.2d8d42c5@the-village.bc.nu> <20070814001441.GN3406@bingen.suse.de> <20070814191158.GB14093@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814191158.GB14093@hexapodia.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> bcm43xx hardware does show up on low-end MIPS boxes (wrt54g anybody?)
> that would be sorely hurt by excess copies.

Lowend boxes don't have more than 1GB of RAM. With <= 1GB you don't
need to copy on bcm43xx.

-Andi
