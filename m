Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbZEKHAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbZEKHAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 03:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZEKHAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 03:00:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52500 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZEKHAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 03:00:33 -0400
Date: Mon, 11 May 2009 03:00:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Export GPIO control symbols from mfp-pxa2xx.c
Message-ID: <20090511070029.GA20226@infradead.org>
References: <Pine.LNX.4.64.0905110740230.7176@venus.araneidae.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905110740230.7176@venus.araneidae.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 07:43:29AM +0100, Michael Abbott wrote:
> With very lightweight board support providing a number of uncommitted GPIO 
> pins I found that my out of kernel driver needs to call symbols that 
> aren't actually exported.  This patch adds these exports.

As usual we don't export symbols for out of tree drivers.

