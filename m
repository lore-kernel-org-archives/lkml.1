Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbZHQJWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbZHQJWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932165AbZHQJWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:22:49 -0400
Received: from www84.your-server.de ([213.133.104.84]:51880 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbZHQJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:22:48 -0400
Subject: Re: [PATCH 2/7] kfifo: move out spinlock
From: Stefani Seibold <stefani@seibold.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
In-Reply-To: <20090817094842.1d97f841@lxorguk.ukuu.org.uk>
References: <1250455161.28540.4.camel@wall-e>
	 <1250455590.28540.10.camel@wall-e>
	 <20090816235843.0f7f11de@lxorguk.ukuu.org.uk>
	 <20090816163422.a147a918.akpm@linux-foundation.org>
	 <20090817074820.3585206b@lxorguk.ukuu.org.uk>
	 <20090817003617.2abe0a95.akpm@linux-foundation.org>
	 <20090817090829.689a604c@lxorguk.ukuu.org.uk>
	 <20090817012150.9bb699ed.akpm@linux-foundation.org>
	 <20090817094842.1d97f841@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 11:22:43 +0200
Message-Id: <1250500963.25359.8.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 17.08.2009, 09:48 +0100 schrieb Alan Cox:
> What it does do is make the code more verbose, wider, more likely to
> go
> over 80 columns and more typing.

I don't think so, because kfifo_*_locked() is only there for a
simplified porting. New user will not normally not use it.

Stefani

