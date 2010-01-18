Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226Ab0AROat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0AROat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212Ab0AROar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:30:47 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51354 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753194Ab0AROaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:30:46 -0500
Date: Mon, 18 Jan 2010 14:32:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gleb Natapov <gleb@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, akpm@linux-foundation.org,
       andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Message-ID: <20100118143232.0a0c4b4d@lxorguk.ukuu.org.uk>
In-Reply-To: <20100118141938.GI30698@redhat.com>
References: <20100118133755.GG30698@redhat.com>
	<84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>
	<20100118141938.GI30698@redhat.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> this kind of control. As of use of mlockall(MCL_FUTURE) how can I make
> sure that all memory allocated behind my application's back (by dynamic
> linker, libraries, stack) will be locked otherwise?

If you add this flag you can't do that anyway - some library will
helpfully start up using it and then you are completely stuffed or will
be back in two or three years adding MLOCKALL_ALWAYS.

Alan
