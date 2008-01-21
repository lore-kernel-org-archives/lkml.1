Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbYAUX5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbYAUX5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYAUX5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:57:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54978 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955AbYAUX5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:57:24 -0500
Date: Mon, 21 Jan 2008 15:57:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/6] RFC: Typesafe callbacks
In-Reply-To: <200801221027.15002.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.00.0801211547160.2957@woody.linux-foundation.org>
References: <200801202046.14746.rusty@rustcorp.com.au> <200801212233.04989.rusty@rustcorp.com.au> <47949257.1000102@gmail.com> <200801221027.15002.rusty@rustcorp.com.au>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Jan 2008, Rusty Russell wrote:
>
> Attempt to create callbacks which take unsigned long as well as
> correct pointer types.

I bow down before you.

I thought I had done some rather horrible things with gcc built-ins and 
macros, but I hereby hand over my crown to you.

As my daughter would say: that patch fell out of the ugly tree, and hit 
every branch on the way down. Very impressive.

All hail Rusty, undisputed ruler of Ugly-land.

Side note: can you verify that __builtin_choose_expr() exists in gcc-3? I 
don't think we've relied on it before except on arm, and that one has 
always had its own compiler version dependencies..

			Linus
