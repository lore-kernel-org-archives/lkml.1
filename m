Return-Path: <linux-kernel-owner+w=401wt.eu-S1761930AbYBRVHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761930AbYBRVHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762682AbYBRVF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:05:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49521 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762181AbYBRVF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:05:27 -0500
Date: Mon, 18 Feb 2008 13:04:22 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: benh@kernel.crashing.org, Christian Krafft <krafft@de.ibm.com>,
       linux-kernel@vger.kernel.org, parabelboi@bopserverein.de,
       linuxppc-dev@ozlabs.org
Subject: Re: [Patch 0/2] powerpc: avoid userspace poking to legacy ioports
Message-ID: <20080218130422.6ee10099@laptopd505.fenrus.org>
In-Reply-To: <20080218215842.66bb004f@hyperion.delvare>
References: <20080213182800.5c6940a8@de.ibm.com>
	<20080213183506.7f3e3145@de.ibm.com>
	<1202935374.7296.44.camel@pasglop>
	<20080218211519.2b159ade@hyperion.delvare>
	<1203367323.6740.21.camel@pasglop>
	<20080218215842.66bb004f@hyperion.delvare>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 21:58:42 +0100
Jean Delvare <khali@linux-fr.org> wrote:

> On Tue, 19 Feb 2008 07:42:03 +1100, Benjamin Herrenschmidt wrote:
> > 
> > > Maybe Christian's patch can be improved to not do the check on
> > > these? As long as /dev/port exists, it seems reasonable that the
> > > kernel should behave, no matter what I/O ports are accessed from
> > > user-space.
> > 
> > nonsense.
> > 
> >  /dev/mem exists for example, but you are still not supposed to go
> > bang all over the place in it.
> 
> You should at least be able to read from it without crashing the
> machine. Of course writing is a different story.

keep dreaming. This is not how /dev/mem works today, not on x86 and very likely not on ppc either.

