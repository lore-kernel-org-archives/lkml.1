Return-Path: <linux-kernel-owner+w=401wt.eu-S933102AbZLRWBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102AbZLRWBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 17:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbZLRWBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 17:01:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751234AbZLRWBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 17:01:18 -0500
Date: Fri, 18 Dec 2009 14:00:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andy Walls <awalls@radix.net>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Fwd: [patch] media video cx23888 driver: ported to new kfifo
 API]
Message-Id: <20091218140026.15416033.akpm@linux-foundation.org>
In-Reply-To: <1261173442.13019.13.camel@wall-e>
References: <4B2B5622.80604@infradead.org>
	<1261137648.3080.36.camel@palomino.walls.org>
	<1261138265.8293.2.camel@wall-e>
	<1261172359.3060.11.camel@palomino.walls.org>
	<1261173442.13019.13.camel@wall-e>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 22:57:22 +0100
Stefani Seibold <stefani@seibold.net> wrote:

> But kfifo_len() did not
> requiere a lock in my opinion. It is save to use without a look. 

What do you mean by this?  Safe in general, or safe in this particular driver?

In either case: why?
