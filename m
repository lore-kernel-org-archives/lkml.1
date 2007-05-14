Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbXENVyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbXENVyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbXENVyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:54:10 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3660 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbXENVyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:54:09 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 14 May 2007 14:54:07 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [patch 1/1] export eventfd symbols ...
In-Reply-To: <20070514145137.30e6d019.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705141453200.19682@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.25077.1179178493.1>
 <20070514214201.GA24107@infradead.org> <Pine.LNX.4.64.0705141443440.19682@alien.or.mcafeemobile.com>
 <20070514145137.30e6d019.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007, Andrew Morton wrote:

> On Mon, 14 May 2007 14:45:26 -0700 (PDT)
> Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > On Mon, 14 May 2007, Christoph Hellwig wrote:
> > 
> > > On Mon, May 14, 2007 at 02:34:53PM -0700, Davide Libenzi wrote:
> > > > Export eventfd kernel functions to modules.
> > > 
> > > Why?
> > 
> > KVM developers asked for it. It seem they'll be using eventfd to signal 
> > events to userspace.
> > 
> 
> yeah, there's no really easy way of doing this.  Probably it's best if
> these exports get merged via the KVM git tree, once the proposed KVM
> changes have been suitably reviewed.

That sounds reasonable.



- Davide


