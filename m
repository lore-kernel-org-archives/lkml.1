Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbYBKSTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbYBKSTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbYBKSTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:19:40 -0500
Received: from hiauly1.hia.nrc.ca ([132.246.100.193]:3339 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbYBKSTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:19:39 -0500
X-Greylist: delayed 1493 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2008 13:19:38 EST
Message-Id: <200802111708.m1BH8q3p008073@hiauly1.hia.nrc.ca>
Subject: Re: [PATCH?][arch/parisc/kernel/pci-dma.c]      pcxl_dma_ops.alloc_noncoherent
To: 12o3l@tiscali.nl (Roel Kluin)
Date: Mon, 11 Feb 2008 12:08:51 -0500 (EST)
From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Cc: James.Bottomley@HansenPartnership.com, kyle@parisc-linux.org,
       matthew@wil.cx, grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <47B07E76.9000100@tiscali.nl> from "Roel Kluin" at Feb 11, 2008 05:57:26 pm
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> James Bottomley wrote:
> > On Mon, 2008-02-11 at 17:23 +0100, Roel Kluin wrote:
> >> duplicate pa11_dma_alloc_consistent; more appropriate appears
> >> pa11_dma_alloc_noncoherent here. 
> >>
> >> Not tested, please confirm that this fix is correct
> > 
> > No, it looks completely incorrect to me.  What makes you think a pcxl
> > box has a problem with coherency?
> 
> Ok, please ignore the patch then. It just appeared suspicious to me
> that the function did exist, but the names assigned were different.

How about a comment?

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
