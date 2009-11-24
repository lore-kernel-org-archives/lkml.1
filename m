Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbZKXGwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbZKXGwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 01:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757920AbZKXGwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 01:52:23 -0500
Received: from www84.your-server.de ([213.133.104.84]:60964 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917AbZKXGwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 01:52:22 -0500
Subject: Re: [PATCH 5/7] kfifo: add DEFINE_KFIFO and friends, add very tiny
 functions
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <20091123141910.af8f0d30.akpm@linux-foundation.org>
References: <1258704942.4426.5.camel@wall-e>
	 <1258705633.4426.16.camel@wall-e>
	 <20091123141910.af8f0d30.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 24 Nov 2009 07:52:25 +0100
Message-ID: <1259045545.14668.2.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 23.11.2009, 14:19 -0800 schrieb Andrew Morton:
> On Fri, 20 Nov 2009 09:27:13 +0100
> Stefani Seibold <stefani@seibold.net> wrote:
> 
> > +#define __kfifo_initializer(s, b) \
> > +	(struct kfifo) { \
> > +		.size	= s, \
> > +		.in	= 0, \
> > +		.out	= 0, \
> > +		.buffer = b \
> > +	}
> 
> This could be #undef'ed after its last invokation, assuming that it is
> not intended that .c files use __kfifo_initializer().  

Will be fixed...


