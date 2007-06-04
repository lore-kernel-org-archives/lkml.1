Return-Path: <linux-kernel-owner+w=401wt.eu-S1762231AbXFDWyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762231AbXFDWyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757143AbXFDWyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:54:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45205 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755853AbXFDWyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:54:07 -0400
Date: Mon, 4 Jun 2007 15:53:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Message-Id: <20070604155355.bf29a3a8.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706041532350.27125@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
	<alpine.LFD.0.98.0706041143240.23741@woody.linux-foundation.org>
	<Pine.LNX.4.64.0706041200140.24550@schroedinger.engr.sgi.com>
	<84144f020706041213x1d241794u98e9b3ca29865033@mail.gmail.com>
	<Pine.LNX.4.64.0706041213540.24935@schroedinger.engr.sgi.com>
	<46646747.2080803@cs.helsinki.fi>
	<Pine.LNX.4.64.0706041532350.27125@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007 15:39:08 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> > Btw, if I am again missing something totally obvious, could you please be so
> > kind to send me a batch of the same pills that the smart people take. I am all
> > out.
> 
> Heheheh.... Mind boogling isnt it? Patch duplicity....
> 
> Seriously: Andrew/Linus could you make up your mind which way we are 
> going here? 

I've no strong opinions - I'm just randomly waffling.
 
> I'd say lets drop the DEVELKERNEL stuff and the warnings and go with 
> ZERO_SIZE_PTR. The DEVELKERNEL patch has the danger that subtle changes 
> occur at release time that we have not anticipated.

OK.
