Return-Path: <linux-kernel-owner+w=401wt.eu-S1761599AbZFKQBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761599AbZFKQBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbZFKQB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:01:27 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36416 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbZFKQB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:01:27 -0400
Subject: Re: [PATCH] init: introduce mm_init()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu
In-Reply-To: <alpine.LFD.2.01.0906110854450.3573@localhost.localdomain>
References: <Pine.LNX.4.64.0906111846590.16970@melkki.cs.Helsinki.FI>
	 <alpine.LFD.2.01.0906110854450.3573@localhost.localdomain>
Date: Thu, 11 Jun 2009 19:01:28 +0300
Message-Id: <1244736088.4830.2.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, 2009-06-11 at 08:56 -0700, Linus Torvalds wrote:
> Please just put the comments at the top of the function in cases like 
> this, ie just
> 
> 	/*
> 	 * ...
> 	 */
> 	static int __init mm_init(void)
> 	{
> 		..
> 	}

Fixed.

On Thu, 2009-06-11 at 08:56 -0700, Linus Torvalds wrote:
> also, I'm now terminally confused about the whole series, so I'm wondering 
> if you could re-do the series so that (a) I have a clear picture of what 
> to take, and (b) preferably so it's also all bisectable (ie the trap_init 
> ordering fixes are done in the initial mm/init.c changes).

Yup, I will do that and send a v3 of the pull request. I am compiling a
kernel here to try out my tree on 32-bit. I think Ingo is busy preparing
his remaining merges now so I haven't gotten confirmation from him
whether my patch fixes the problem he saw or not.

			Pekka

