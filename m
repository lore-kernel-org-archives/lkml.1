Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbZEKH25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbZEKH25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 03:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZEKH2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 03:28:47 -0400
Received: from araneidae.co.uk ([62.3.233.233]:4436 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZEKH2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 03:28:46 -0400
Date: Mon, 11 May 2009 08:28:40 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: Christoph Hellwig <hch@infradead.org>
cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Export GPIO control symbols from mfp-pxa2xx.c
In-Reply-To: <20090511070029.GA20226@infradead.org>
Message-ID: <Pine.LNX.4.64.0905110824560.7447@venus.araneidae.co.uk>
References: <Pine.LNX.4.64.0905110740230.7176@venus.araneidae.co.uk>
 <20090511070029.GA20226@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Christoph Hellwig wrote:
> On Mon, May 11, 2009 at 07:43:29AM +0100, Michael Abbott wrote:
> > With very lightweight board support providing a number of uncommitted GPIO 
> > pins I found that my out of kernel driver needs to call symbols that 
> > aren't actually exported.  This patch adds these exports.
> As usual we don't export symbols for out of tree drivers.

I understand that's the default condition, but presumably there's no 
compelling reason for the mfp configuration functions to be withheld (I 
was simply trying to obey the obsolescence instructions in pxa2xx-gpio.h!)

As for bringing this driver in tree?  Not a great deal of point, in this 
particular case, but I have no problem with doing that.

P.S.  For anybody watching this with linux-arm-kernel access -- my 
messages are sticking despite having apparently subscribed...
