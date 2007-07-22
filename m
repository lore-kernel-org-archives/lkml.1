Return-Path: <linux-kernel-owner+w=401wt.eu-S1765312AbXGVJSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765312AbXGVJSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 05:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761060AbXGVJSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 05:18:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50398 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764549AbXGVJSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 05:18:31 -0400
Date: Sun, 22 Jul 2007 11:18:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Create clflush() inline, remove hardcoded wbinvd
Message-ID: <20070722091826.GA28313@one.firstfloor.org>
References: <1184885740.16311.19.camel@t60> <200707202119.l6KLJwcd004205@tazenda.hos.anvin.org> <20070720212741.GB565@one.firstfloor.org> <46A12A3A.4020305@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A12A3A.4020305@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 02:33:46PM -0700, H. Peter Anvin wrote:
> Andi Kleen wrote:
> > On Fri, Jul 20, 2007 at 02:19:58PM -0700, H. Peter Anvin wrote:
> >> Create an inline function for clflush(), with the proper arguments,
> >> and use it instead of hard-coding the instruction.
> >>
> >> This also removes one instance of hard-coded wbinvd, based on a patch
> >> by Bauder de Oliveira Costa.
> > 
> > I don't see much sense in it. CLFLUSH is not priviledged, paravirt
> > doesn't need to change and this adds just an unnecessary layer of abstraction.
> 
> The main reason is that everyone seems to invoke it either incorrectly

Where is it incorrect? 

-Andi
