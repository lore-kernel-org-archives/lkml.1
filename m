Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbXCWAJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbXCWAJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 20:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbXCWAJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 20:09:56 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:52661 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbXCWAJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 20:09:55 -0400
Date: Fri, 23 Mar 2007 01:10:02 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: request_queue_t depends on CONFIG_BLOCK
Message-ID: <20070323001002.GA14583@aepfle.de>
References: <20070322215234.GA13219@aepfle.de> <20070322215351.GA7216@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070322215351.GA7216@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, Christoph Hellwig wrote:

> On Thu, Mar 22, 2007 at 10:52:34PM +0100, Olaf Hering wrote:
> > How can this compile error be fixed properly?
> > request_queue_t is inside CONFIG_BLOCK,
> > ide_drive_s (and likely others) use it unconditionally.
> > 
> > 
> >   CC      arch/powerpc/kernel/setup_64.o
> > In file included from linux-2.6.21-rc4/arch/powerpc/kernel/setup_64.c:23:
> 
> start looking for the problem here.  Why does you arch code include ide.h?

Because it is needed in a few places.
Better hide everything in ide.h inside #ifdef CONFIG_IDE
