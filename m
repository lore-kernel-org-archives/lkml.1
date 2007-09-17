Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbXIQJsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbXIQJsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbXIQJsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 05:48:45 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:49121 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbXIQJso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 05:48:44 -0400
Subject: Re: rtl8187 driver in 2.6.23-rc6-git5: kernel panic if not used as
	a module. Works as a module.
From: Johannes Berg <johannes@sipsolutions.net>
To: eric.valette@free.fr
Cc: "\"Paul Rolland"
	 =?UTF-8?Q?=28=E3=83=9D=E3=83=BC=E3=83=AB=E3=83=BB=E3=83=AD=E3=83=A9?=
	 =?UTF-8?Q?=E3=83=B3=29=22?= <rol@witbe.net>,
       Rob Hussey <robjhussey@gmail.com>, flamingice@sourmilk.net,
       andreamrl@tiscali.it, linux-kernel@vger.kernel.org
In-Reply-To: <46EC2BBB.1030506@free.fr>
References: <46EBE70C.2040201@free.fr>	<46EBEBD2.7060502@free.fr>
	 <6b8cef970709150928h25a7093md5f86d2bdcf677cc@mail.gmail.com>
	 <46EC24B6.2030709@free.fr> <20070915185153.08490a9b@tux.DEF.witbe.net>
	 <46EC2BBB.1030506@free.fr>
Content-Type: text/plain
Date: Mon, 17 Sep 2007 11:48:35 +0200
Message-Id: <1190022515.3934.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sa, 2007-09-15 at 21:00 +0200, Eric Valette wrote:

> I came to this conclusion too. But I would have preferred to have
> #define subsys_exit(fn)			modules_exit(fn)
> 
> in the case of a module and nop in the non module case...

module_exit is a no-op anyway in the non-modular case, it's never
called, so what's the point?

johannes

