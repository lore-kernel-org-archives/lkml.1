Return-Path: <linux-kernel-owner+w=401wt.eu-S966098AbXDBXYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966098AbXDBXYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 19:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966102AbXDBXYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 19:24:17 -0400
Received: from smtp.osdl.org ([65.172.181.24]:52628 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966098AbXDBXYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 19:24:16 -0400
Date: Mon, 2 Apr 2007 16:23:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, pmarques@grupopie.com,
       linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 5/5] Fix race between cat /proc/slab_allocators and
 rmmod
Message-Id: <20070402162324.d9dd27c1.akpm@linux-foundation.org>
In-Reply-To: <1175555395.12230.451.camel@localhost.localdomain>
References: <20070402150316.GE6735@localhost.sw.ru>
	<1175555395.12230.451.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2007 09:09:55 +1000
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Mon, 2007-04-02 at 19:03 +0400, Alexey Dobriyan wrote:
> > Same story as with cat /proc/*/wchan race vs rmmod race, only
> > /proc/slab_allocators want more info than just symbol name.
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> 
> All these look excellent.  I hope Andrew picked them up?
> 

I wasn't cc'ed on them, but I'll push them into the hole marked "In" anyway.

