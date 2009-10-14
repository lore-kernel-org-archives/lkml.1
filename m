Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbZJNCne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbZJNCne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 22:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbZJNCnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 22:43:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752686AbZJNCnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 22:43:33 -0400
Date: Tue, 13 Oct 2009 19:41:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Michael Reed <mreed10@us.ibm.com>,
       stable@kernel.org
Subject: Re: [PATCH] 8250_pci: Add IBM Saturn serial card
Message-Id: <20091013194121.49d2d9ae.akpm@linux-foundation.org>
In-Reply-To: <1255477253.2347.22.camel@pasglop>
References: <1255477253.2347.22.camel@pasglop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009 10:40:53 +1100 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> The IBM Saturn serial card has only one port. Without that fixup,
> the kernel thinks it has two, which confuses userland setup and
> admin tools as well.
> 

That sounds seriousish.  I assume it's a long-standing problem, but we
only just noticed it?

I'll cc -stable because it's so simple ;)

> 
> Andrew & Others on CC... not sure who takes care of patches to
> that driver nowadays. Should I send directly to Linus ?

I'll grab them if I see them, especially simple ones.  Sometimes Alan
grabs them too.
