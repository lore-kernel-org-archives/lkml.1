Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbXC3RBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbXC3RBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 13:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbXC3RBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 13:01:50 -0400
Received: from smtp.osdl.org ([65.172.181.24]:41901 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbXC3RBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 13:01:49 -0400
Date: Fri, 30 Mar 2007 10:01:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm3: fix e1000 compilation
Message-Id: <20070330100104.9b770cd8.akpm@linux-foundation.org>
In-Reply-To: <460D2108.1080101@intel.com>
References: <20070330085029.GA6556@localhost.sw.ru>
	<460D2108.1080101@intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 07:39:04 -0700 "Kok, Auke" <auke-jan.h.kok@intel.com> wrote:

> Alexey Dobriyan wrote:
> >   CC [M]  drivers/net/e1000/e1000_main.o
> > drivers/net/e1000/e1000_main.c: In function 'e1000_tso':
> > drivers/net/e1000/e1000_main.c:2968: error: dereferencing pointer to incomplete type
> > 	...
> > 
> 
> can you send me your config? I'd like to see why nobody here didn't spot this on 
> any of our tests.
> 

test.kernel.org got thoroughly broken by e1000, but Alexey's patch fixed things
up.
