Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbYFEQEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbYFEQEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756825AbYFEQEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:04:37 -0400
Received: from waste.org ([66.93.16.53]:47656 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbYFEQEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:04:36 -0400
Subject: Re: [PATCH 3/5] pagemap: Make pagemap_read enforce reading in
	multiples of 8
From: Matt Mackall <mpm@selenic.com>
To: Thomas Tuttle <ttuttle@google.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <4ca0a85e0806050806r38de18dft8927e093a8e47abd@mail.gmail.com>
References: <4ca0a85e0806050806r38de18dft8927e093a8e47abd@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 11:03:42 -0500
Message-Id: <1212681822.3953.162.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-05 at 11:06 -0400, Thomas Tuttle wrote:
> Since kpagecount and kpageflags require reads in multiples of 8, and
> it simplifies add_to_pagemap significantly, I added the same
> requirement to /proc/pid/pagemap.

I'm generally fine with this. Another approach that's perhaps more
friendly is when someone tries to do a 24-byte read, do a 16-byte read,
leaving the file pointer aligned. Not sure if that's completely kosher
though.

-- 
Mathematics is the supreme nostalgia of our time.

