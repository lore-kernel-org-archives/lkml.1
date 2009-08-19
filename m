Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbZHSVIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbZHSVIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 17:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZHSVIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 17:08:22 -0400
Received: from www84.your-server.de ([213.133.104.84]:39504 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbZHSVIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 17:08:22 -0400
Subject: Re: [PATCH 4/7] kfifo: rename kfifo_put... into kfifo_in... and
 kfifo_get... into kfifo_out...
From: Stefani Seibold <stefani@seibold.net>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <1250715819.3407.88.camel@Joe-Laptop.home>
References: <1250714990.13476.3.camel@wall-e>
	 <1250715606.13476.15.camel@wall-e>
	 <1250715819.3407.88.camel@Joe-Laptop.home>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 23:08:27 +0200
Message-Id: <1250716107.13476.22.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 19.08.2009, 14:03 -0700 schrieb Joe Perches:
> On Wed, 2009-08-19 at 23:00 +0200, Stefani Seibold wrote:
> > rename kfifo_put... into kfifo_in... to prevent miss use of old non in kernel-tree drivers
> > ditto for kfifo_get... -> kfifo_out...
> 
> I would have thought
> 	kfifo_put -> kfifo_out
> 	kfifo_get -> kfifo_in
> but maybe that's just me.
> 

FIFO -> first in, first out

so a put is logical an "in" into the FIFO, and a get is logical an "out"
into the FIFO.


