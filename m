Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbZHSVEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbZHSVEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 17:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbZHSVEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 17:04:13 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1653 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbZHSVEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 17:04:12 -0400
Subject: Re: [PATCH 4/7] kfifo: rename kfifo_put... into kfifo_in... and
 kfifo_get... into kfifo_out...
From: Joe Perches <joe@perches.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <1250715606.13476.15.camel@wall-e>
References: <1250714990.13476.3.camel@wall-e>
	 <1250715606.13476.15.camel@wall-e>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 14:03:39 -0700
Message-Id: <1250715819.3407.88.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 23:00 +0200, Stefani Seibold wrote:
> rename kfifo_put... into kfifo_in... to prevent miss use of old non in kernel-tree drivers
> ditto for kfifo_get... -> kfifo_out...

I would have thought
	kfifo_put -> kfifo_out
	kfifo_get -> kfifo_in
but maybe that's just me.

