Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbZBZBAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbZBZBAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 20:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbZBZA76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:59:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50014
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752731AbZBZA75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:59:57 -0500
Date: Wed, 25 Feb 2009 16:59:40 -0800 (PST)
Message-Id: <20090225.165940.116607063.davem@davemloft.net>
To: hpa@zytor.com
Cc: jengelh@medozas.de, arnd@arndb.de, sam@ravnborg.org, kyle@infradead.org,
       mingo@elte.hu, jaswinderrajput@gmail.com, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, netfilter-devel@vger.kernel.org,
       coreteam@netfilter.org
Subject: Re: [patch 5/7] make netfilter use strict integer types
From: David Miller <davem@davemloft.net>
In-Reply-To: <49A5E92E.8080505@zytor.com>
References: <alpine.LSU.2.00.0902260104220.20789@fbirervta.pbzchgretzou.qr>
	<20090225.165552.32040707.davem@davemloft.net>
	<49A5E92E.8080505@zytor.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 25 Feb 2009 16:58:22 -0800

> David Miller wrote:
> > Disagreed, I think we should have done what Arnd is doing
> > a long time ago.
> > Ending up with linux/types.h in userspace for these kinds of
> > interfaces is already a fore-gone conclusion, it happens
> > already whether you like it or not.
> > And existing apps will work just fine, since they are already
> > getting stdint.h
> > As for compile time, since you're already getting linux/types.h
> > in your apps it's a non-argument.  But even if it was, what
> > are you compiling netfilter utilities on?  A VAX?
> 
> I take it that you're OK that we merge Arnd's patchset?

Yes, ignore Jan, I think he forgot to take his medication today:

Acked-by: David S. Miller <davem@davemloft.net>
