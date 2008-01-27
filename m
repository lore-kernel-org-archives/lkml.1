Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbYA0VVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbYA0VVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbYA0VVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:21:36 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54299 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYA0VVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:21:36 -0500
Date: Sun, 27 Jan 2008 23:21:33 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Jim Houston <jim.houston@ccur.com>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <htejun@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lib/idr.c: initialize struct idr_layer
In-Reply-To: <19f34abd0801271317o4b17dc28l3c93d4d28e3e2e73@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801272319570.540@sbz-30.cs.Helsinki.FI>
References: <19f34abd0801271207j377fba5bg92cedceedbdd228@mail.gmail.com> 
 <84144f020801271300g316b87bgea6beb265b5c62d3@mail.gmail.com>
 <19f34abd0801271317o4b17dc28l3c93d4d28e3e2e73@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

On Sun, 27 Jan 2008, Vegard Nossum wrote:
> Though in this case, idr_pre_get() actually *is* called first. Hmm...
> I think there's a pretty big chance that kmemcheck is at fault :-(

Depends on how you track object initialization. An object returned by 
kmem_cache_alloc() is always initialized if the cache it comes from has a 
constructor.

			Pekka
