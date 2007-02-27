Return-Path: <linux-kernel-owner+w=401wt.eu-S1751104AbXB0NUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104AbXB0NUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 08:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbXB0NUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 08:20:34 -0500
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:60839 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbXB0NUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 08:20:33 -0500
Date: Tue, 27 Feb 2007 08:20:21 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ioread32 endianess.
Message-ID: <20070227132021.GC3545@athena.road.mcmartin.ca>
References: <f19298770702260736i51622584r1979a202bdc64c1d@mail.gmail.com> <20070226160450.GB3787@athena.road.mcmartin.ca> <f19298770702270431i198e032fhe025e221a625140f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770702270431i198e032fhe025e221a625140f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 03:31:20PM +0300, Alexey Zaytsev wrote:
> Than how should one write a portable endian-independent driver? Should
> I wrap ioread32 with an le32_to_cpu?
> 

PCI is always little endian, unless it's not. In which case you're probably
dealing with a graphics card which likely has some kind of palindromic
register which you can read and write to set the endianness of the host
interface. Whoo. Run on sentence.
