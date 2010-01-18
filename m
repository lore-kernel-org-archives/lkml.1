Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303Ab0AROfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab0AROfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068Ab0AROfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:35:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab0AROff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:35:35 -0500
Date: Mon, 18 Jan 2010 16:35:16 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, akpm@linux-foundation.org,
       andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Message-ID: <20100118143516.GK30698@redhat.com>
References: <20100118133755.GG30698@redhat.com>
 <84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>
 <20100118141938.GI30698@redhat.com>
 <20100118143232.0a0c4b4d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118143232.0a0c4b4d@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 02:32:32PM +0000, Alan Cox wrote:
> > this kind of control. As of use of mlockall(MCL_FUTURE) how can I make
> > sure that all memory allocated behind my application's back (by dynamic
> > linker, libraries, stack) will be locked otherwise?
> 
> If you add this flag you can't do that anyway - some library will
> helpfully start up using it and then you are completely stuffed or will
> be back in two or three years adding MLOCKALL_ALWAYS.
> 
Libraries can do many other bad things. They can do mlockall(0) today
too and this is not the reason to ditch mlockall(). I don't expect libc will
do that though.

--
			Gleb.
