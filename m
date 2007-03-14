Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbXCNPu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbXCNPu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXCNPu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:50:27 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42800 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbXCNPu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:50:26 -0400
Date: Wed, 14 Mar 2007 08:49:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <p73slc8863r.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0703140847380.9690@woody.linux-foundation.org>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Mar 2007, Andi Kleen wrote:
> 
> NACK. I think the current ways work just fine. 

Andi, the current ways do *not* work just fine. 

I don't understand why you have problems with obvious cleanups. You also 
nack'ed the file movement to at least make this kind of thing consistent 
(ie the header file movement in commit 2272b0e03) to  at least only have 
symlinks pointing one way.

The current situation is horrible. We've had bugs simply because people 
didn't even *realize* that a file in arch/i386/ was also used by x86-64.

			Linus
