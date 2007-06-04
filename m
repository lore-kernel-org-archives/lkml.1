Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbXFDWa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbXFDWa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758144AbXFDWaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:30:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43457 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991AbXFDWaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:30:20 -0400
Message-ID: <46646747.2080803@cs.helsinki.fi>
Date: Mon, 04 Jun 2007 22:25:59 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>  <alpine.LFD.0.98.0706041143240.23741@woody.linux-foundation.org>  <Pine.LNX.4.64.0706041200140.24550@schroedinger.engr.sgi.com> <84144f020706041213x1d241794u98e9b3ca29865033@mail.gmail.com> <Pine.LNX.4.64.0706041213540.24935@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706041213540.24935@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> That is another patchset. See 
> http://marc.info/?l=linux-kernel&w=2&r=1&s=DEVELKERNEL&q=b

Oh my, I am totally confused now.

First you fix kmalloc(0) to be legal and safe. And then you want to 
DEVEL_WARN_ON_ONCE when size is zero so people can fix their code?

I don't get it.

I thought we wanted to support kmalloc(0) so that as long as you don't 
dereference the pointer, it's all legal and good. Right? So we obviously 
should shut up the WARN_ON because if you do oops, you can clearly see 
that it happened at ZERO_SIZE_PTR and have a nice stack trace anyway...

Btw, if I am again missing something totally obvious, could you please 
be so kind to send me a batch of the same pills that the smart people 
take. I am all out.

			Pekka
