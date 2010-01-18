Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014Ab0ARTI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab0ARTI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 14:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960Ab0ARTI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 14:08:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33974 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754248Ab0ARTI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 14:08:26 -0500
Date: Mon, 18 Jan 2010 19:10:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gleb Natapov <gleb@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, akpm@linux-foundation.org,
       andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Message-ID: <20100118191031.0088f49a@lxorguk.ukuu.org.uk>
In-Reply-To: <20100118181942.GD22111@redhat.com>
References: <20100118133755.GG30698@redhat.com>
	<84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>
	<20100118141938.GI30698@redhat.com>
	<84144f021001180805q4d1203b8qab8ccb1de87b2866@mail.gmail.com>
	<20100118170816.GA22111@redhat.com>
	<84144f021001181009m52f7eaebp2bd746f92de08da9@mail.gmail.com>
	<20100118181942.GD22111@redhat.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I can't realistically chase every address space mapping changes and mlock
> new areas. The only way other then mlockall() is to use custom memory
> allocator that allocates mlocked memory.

Which keeps all the special cases in your app rather than in every single
users kernel. That seems to be the right way up, especially as you can
make a library of it !

Alan
