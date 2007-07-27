Return-Path: <linux-kernel-owner+w=401wt.eu-S1760513AbXG0S1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760513AbXG0S1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbXG0S1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:27:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42632 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756600AbXG0S1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:27:39 -0400
Date: Fri, 27 Jul 2007 11:27:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sparse@vger.kernel.org
Subject: Re: [PATCH] CodingStyle: proscribe do-while without braces.
Message-Id: <20070727112723.131753f9.akpm@linux-foundation.org>
In-Reply-To: <1185555916.2642.8.camel@josh-work.beaverton.ibm.com>
References: <1185485822.4459.1.camel@josh-work.beaverton.ibm.com>
	<m3abtir95x.fsf@maximus.localdomain>
	<20070726173501.9ba466ba.akpm@linux-foundation.org>
	<m3bqdx6dlq.fsf@maximus.localdomain>
	<1185555916.2642.8.camel@josh-work.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 10:05:16 -0700
Josh Triplett <josht@linux.vnet.ibm.com> wrote:

> > Sparse warnings... I think it shouldn't complain either, unless
> > called with extra parameter.
> 
> Good point; Sparse shouldn't warn about this by default.  I've turned
> that off in latest Sparse from Git, so you need to give -Wdo-while or
> -Wall to get warnings about that.  However, the kernel gives -Wall, so
> you'll still see the warnings there.

I believe reeducating sparse was the best fix here.  I think I'll now
have a quiet accident with codingstyle-proscribe-do-while-without-braces.patch
