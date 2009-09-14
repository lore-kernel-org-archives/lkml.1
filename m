Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbZINFgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbZINFgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 01:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZINFgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 01:36:09 -0400
Received: from complete.lackof.org ([198.49.126.79]:43720 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbZINFgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 01:36:08 -0400
Date: Sun, 13 Sep 2009 23:36:10 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Mark Hounschell <markh@compro.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org,
       Mark Hounschell <dmarkh@cfl.rr.com>, linux-kernel@vger.kernel.org
Subject: Re: problems doing direct dma from a pci device to pci-e device
Message-ID: <20090914053610.GA5970@lackof.org>
References: <4AAA5B1F.3020103@compro.net> <20090911154714.70a94454@lxorguk.ukuu.org.uk> <4AAA6BE7.8040306@compro.net> <4AAAAD30.4040704@compro.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAAAD30.4040704@compro.net>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 04:04:00PM -0400, Mark Hounschell wrote:
> A quick readup on the IOMMU makes me think that if it does use one, that
> could certainly cause my problem. I'm using bus addresses plugged into
> page tables that live in the gpiohsd card obtained from virt2bus.

If you haven't yet, take a look at Documentation/DMA-API.txt and
DMA-mapping.txt . virt2bus has been deprecated for DMA since 2.4 releases.

grant
