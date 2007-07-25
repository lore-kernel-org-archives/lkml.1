Return-Path: <linux-kernel-owner+w=401wt.eu-S1760890AbXGYFJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbXGYFJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 01:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbXGYFJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 01:09:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:42737 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751498AbXGYFJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 01:09:09 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/wl9xO+azwC1tmvpHEUhxileca7fsfsmBtRviEsW
	yXSdzbjW2ff0iW
Subject: Re: 2.6.23-rc1: BUG_ON in kmap_atomic_prot()
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Christoph Lameter <clameter@sgi.com>
In-Reply-To: <alpine.LFD.0.999.0707241124220.3607@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <20070723183839.GA5874@martell.zuzino.mipt.ru>
	 <20070723190152.GA5755@martell.zuzino.mipt.ru>
	 <20070723132431.42afbae8.akpm@linux-foundation.org>
	 <1185271269.6479.7.camel@Homer.simpson.net>
	 <20070724092839.f0556948.akpm@linux-foundation.org>
	 <alpine.LFD.0.999.0707241124220.3607@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 07:09:03 +0200
Message-Id: <1185340143.6528.1.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 11:25 -0700, Linus Torvalds wrote:
> 
> On Tue, 24 Jul 2007, Andrew Morton wrote:
> > 
> > I guess this was the bug:
> 
> Looks very likely to me. Mike, Alexey, does this fix things for you?

I don't have very much runtime on it yet, but yes, it seems to have.

	-Mike

