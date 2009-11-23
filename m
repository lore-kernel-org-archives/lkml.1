Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbZKWWTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbZKWWTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 17:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757469AbZKWWTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 17:19:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757415AbZKWWTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 17:19:32 -0500
Date: Mon, 23 Nov 2009 14:19:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 5/7] kfifo: add DEFINE_KFIFO and friends, add very tiny
 functions
Message-Id: <20091123141910.af8f0d30.akpm@linux-foundation.org>
In-Reply-To: <1258705633.4426.16.camel@wall-e>
References: <1258704942.4426.5.camel@wall-e>
	<1258705633.4426.16.camel@wall-e>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 09:27:13 +0100
Stefani Seibold <stefani@seibold.net> wrote:

> +#define __kfifo_initializer(s, b) \
> +	(struct kfifo) { \
> +		.size	= s, \
> +		.in	= 0, \
> +		.out	= 0, \
> +		.buffer = b \
> +	}

This could be #undef'ed after its last invokation, assuming that it is
not intended that .c files use __kfifo_initializer().  
