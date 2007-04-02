Return-Path: <linux-kernel-owner+w=401wt.eu-S966087AbXDBXKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966087AbXDBXKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 19:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966094AbXDBXKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 19:10:35 -0400
Received: from ozlabs.org ([203.10.76.45]:34717 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966087AbXDBXKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 19:10:34 -0400
Subject: Re: [PATCH 5/5] Fix race between cat /proc/slab_allocators and
	rmmod
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: pmarques@grupopie.com, linux-kernel@vger.kernel.org, devel@openvz.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070402150316.GE6735@localhost.sw.ru>
References: <20070402150316.GE6735@localhost.sw.ru>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 09:09:55 +1000
Message-Id: <1175555395.12230.451.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 19:03 +0400, Alexey Dobriyan wrote:
> Same story as with cat /proc/*/wchan race vs rmmod race, only
> /proc/slab_allocators want more info than just symbol name.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>

All these look excellent.  I hope Andrew picked them up?

Thanks,
Rusty.


