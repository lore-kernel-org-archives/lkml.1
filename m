Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbXENVvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbXENVvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbXENVvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:51:47 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754450AbXENVvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:51:46 -0400
Date: Mon, 14 May 2007 14:51:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [patch 1/1] export eventfd symbols ...
Message-Id: <20070514145137.30e6d019.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705141443440.19682@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.25077.1179178493.1>
	<20070514214201.GA24107@infradead.org>
	<Pine.LNX.4.64.0705141443440.19682@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 14:45:26 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> On Mon, 14 May 2007, Christoph Hellwig wrote:
> 
> > On Mon, May 14, 2007 at 02:34:53PM -0700, Davide Libenzi wrote:
> > > Export eventfd kernel functions to modules.
> > 
> > Why?
> 
> KVM developers asked for it. It seem they'll be using eventfd to signal 
> events to userspace.
> 

yeah, there's no really easy way of doing this.  Probably it's best if
these exports get merged via the KVM git tree, once the proposed KVM
changes have been suitably reviewed.
