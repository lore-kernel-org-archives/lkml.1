Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbXGZXX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbXGZXX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbXGZXXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:23:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51919 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752882AbXGZXXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:23:18 -0400
Date: Thu, 26 Jul 2007 16:17:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: matthew@wil.cx, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: IRQF_DISABLED problem
In-Reply-To: <alpine.LFD.0.999.0707261557150.3442@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0707261616050.3442@woody.linux-foundation.org>
References: <20070726201355.GP19275@parisc-linux.org>
 <20070726.152352.70218024.davem@davemloft.net>
 <alpine.LFD.0.999.0707261557150.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Jul 2007, Linus Torvalds wrote:
> 
>  (c) "one IRQF_DISABLED means that everything runs disabled". This is 
>      quite possibly buggy.

(Side note: I'm not claiming this (or it's mirror image (d)) is really any 
better/worse than the current behaviour from a theoretical standpoint, but 
at least the current behaviour is _tested_, which makes it better in 
practice. So if we want to change this, I think we want to change it to 
something that is _obviously_ better).

		Linus
