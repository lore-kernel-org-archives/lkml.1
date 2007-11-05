Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbXKETh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbXKETh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 14:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXKEThP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 14:37:15 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35612 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603AbXKEThN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 14:37:13 -0500
Date: Mon, 5 Nov 2007 11:36:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: stable@kernel.org, Hugh Dickins <hugh@veritas.com>,
       Oliv?r Pint?r <oliver.pntr@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
In-Reply-To: <Pine.LNX.4.64.0711051130100.16207@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.0.999.0711051135340.15101@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
 <6101e8c40711031027x3f946b28p324dadeab7c1b2c3@mail.gmail.com>
 <Pine.LNX.4.64.0711031741160.10953@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031847450.13845@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031935510.15611@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031247250.5828@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711031950300.17078@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031253580.6080@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711032007060.17942@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031326450.6227@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711041103030.8179@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711051036250.13139@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711051901330.28390@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711051114560.14913@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0711051126250.15101@woody.linux-foundation.org>
 <Pine.LNX.4.64.0711051130100.16207@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Nov 2007, Christoph Lameter wrote:
>
> > Will you send the equivalent one for the current -git tree?
> 
> I already sent that on Saturday (also sent a version against mm which is 
> a bit different now).

With all the back-and-forth with you and Hugh, I wanted to make sure I 
knew what to apply ;)

> Here is the version against git again:

Thanks,

		Linus
