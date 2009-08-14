Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbZHNRYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbZHNRYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 13:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbZHNRYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 13:24:11 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1812 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbZHNRYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 13:24:11 -0400
Subject: Re: [PATCH 4/6] new kfifo API v0.3 - add DEFINE_KFIFO and friends,
 add very tiny functions
From: Joe Perches <joe@perches.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <1250269434.5644.15.camel@wall-e>
References: <1250250262.19690.95.camel@wall-e>
	 <1250263254.15269.456.camel@Joe-Laptop.home>
	 <1250269434.5644.15.camel@wall-e>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 10:23:33 -0700
Message-Id: <1250270613.15269.464.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-14 at 19:03 +0200, Stefani Seibold wrote:
> Am Freitag, den 14.08.2009, 08:20 -0700 schrieb Joe Perches:
> > > Add INIT_KFIFO - macro to initialize a with DECLARE_KFIFO declared kfifo 
> > What does the description mean?
> Exactly what it meas. If you declare a kfifo with DECLARE_KIFO than you
> must initialize this fifo which INIT_KFIFO.

I recognize the intent, but you should read the description to
yourself slowly.  It's also the same content in the kerneldoc.

Maybe INIT_KFIFO - Initialize a kfifo declared by DECLARED_KFIFO

> > I think you should mention somewhere that these macros
> > actually define 2 objects.  "name##_buffer" might have
> > unexpected clashes and be prefixed with kfifo.
> > maybe something like "kfifo_##name##_buffer"?
> Maybe name it name##_kfifo_buffer?

Your choice.  I think most kernel use prefers prefixes.

> But before doing this i will wait for more response and for inclusion
> into -mm. If i get an okay i will do a maintainance patch. It is to much
> work to handle this splitted patches.

Fine by me. cheers, Joe

