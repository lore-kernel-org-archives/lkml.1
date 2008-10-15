Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbYJOSKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbYJOSKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYJOSKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:10:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042AbYJOSKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:10:14 -0400
Date: Wed, 15 Oct 2008 11:09:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] fastboot: Introduce an asynchronous function call
 mechanism
Message-Id: <20081015110924.82135ec7.akpm@linux-foundation.org>
In-Reply-To: <20081015175252.GA10600@x200.localdomain>
References: <20081012194427.2e21c22e@infradead.org>
	<20081015014117.faff3a61.akpm@linux-foundation.org>
	<20081015075246.2e1610f3@infradead.org>
	<20081015095905.41219c9d.akpm@linux-foundation.org>
	<20081015175252.GA10600@x200.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008 21:52:52 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Wed, Oct 15, 2008 at 09:59:05AM -0700, Andrew Morton wrote:
> > On Wed, 15 Oct 2008 07:52:46 -0400 Arjan van de Ven <arjan@infradead.org> wrote:
> > 
> > > On Wed, 15 Oct 2008 01:41:17 -0700
> > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > > +static int async_active = 0;
> > > > 
> > > > ?
> > > ok will add comment
> > 
> > I was actually "?"ing at the "= 0".  I thought that would be obvious
> > but it's whizzed past two people so far :(
> 
> Is there evidence that some gccs will not add such variable to .bss?

It does get placed in bss.

> Because "= 0;" is more readable.

Only to someone who doesn't know anything about C.

For the rest of us it is inconsistent, is a visual distraction and
wastes space which would be better taken up by a comment explaining the
variable's function (lol).

