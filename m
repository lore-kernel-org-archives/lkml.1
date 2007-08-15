Return-Path: <linux-kernel-owner+w=401wt.eu-S1760294AbXHOLiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294AbXHOLiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 07:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757875AbXHOLiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 07:38:09 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:50860 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467AbXHOLhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 07:37:55 -0400
Date: Wed, 15 Aug 2007 12:37:49 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Lameter <clameter@sgi.com>,
       Mel Gorman <mel@skynet.ie>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the
	zonelist->zones pointer
Message-ID: <20070815113749.GA5862@linux-mips.org>
References: <Pine.LNX.4.64.0708131457190.28445@schroedinger.engr.sgi.com> <20070813225841.GG3406@bingen.suse.de> <Pine.LNX.4.64.0708131506030.28502@schroedinger.engr.sgi.com> <20070813230801.GH3406@bingen.suse.de> <Pine.LNX.4.64.0708131536340.29946@schroedinger.engr.sgi.com> <20070813234322.GJ3406@bingen.suse.de> <Pine.LNX.4.64.0708131553050.30626@schroedinger.engr.sgi.com> <20070814000041.GL3406@bingen.suse.de> <20070814002223.2d8d42c5@the-village.bc.nu> <20070814001441.GN3406@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814001441.GN3406@bingen.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 02:14:41AM +0200, Andi Kleen wrote:

> meth is only used on SGI O2s which are not that slow and unlikely
> to work in tree anyways.

O2 doesn't enable CONFIG_ZONE_DMA so there is no point in using GFP_DMA in
an O2-specific device driver.  Will send out patch in separate mail.

  Ralf
