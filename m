Return-Path: <linux-kernel-owner+w=401wt.eu-S1161521AbXBHEee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161521AbXBHEee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 23:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161518AbXBHEee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 23:34:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54575 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161521AbXBHEed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 23:34:33 -0500
Date: Wed, 7 Feb 2007 20:34:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix cc-option-yn whitespace
In-Reply-To: <20070208033046.44D39180055@magilla.sf.frob.com>
Message-ID: <Pine.LNX.4.64.0702072024330.8424@woody.linux-foundation.org>
References: <20070208033046.44D39180055@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Feb 2007, Roland McGrath wrote:

> This change:
> 
> 	commit 5de043f4bd11a9e0a3e8daec7d1905da575a76b7
> 	Author: Oleg Verych <olecom@flower.upol.cz>
> 	Date:   Tue Feb 6 02:18:21 2007 +0100
> 
> 	    [PATCH] kbuild: improve option checking, Kbuild.include cleanup
> 
> introduced leading whitespace in the results of cc-option-yn and such.
> This breaks some of their uses, like HAS_MTUNE in arch/i386/Makefile.cpu.

Yes.. It doesn't seem to happen with make-3.81, for some reason, and I 
don't see why the leading space happens. Maybe somebody with deep GNU make 
knowledge knows.

I committed the hopefully equivalent patch (that also removes the 
symlinking to /dev/null that Roman objected to).

			Linus
