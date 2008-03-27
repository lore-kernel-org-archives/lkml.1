Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbYC0XOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbYC0XOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYC0XOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:14:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015AbYC0XOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:14:35 -0400
Date: Thu, 27 Mar 2008 16:14:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] ptrace: arch_ptrace cleanup
In-Reply-To: <20080327230623.969FF26FA1C@magilla.localdomain>
Message-ID: <alpine.LFD.1.00.0803271612360.14670@woody.linux-foundation.org>
References: <20080327230623.969FF26FA1C@magilla.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 Mar 2008, Roland McGrath wrote:
>
> This intends to remove the last bit of entanglement with core ptrace
> implementation details in arch code's arch_ptrace and arch_compat_ptrace.

So I think this has a nicer calling convention, but you never answered the 
question about what the *point* of this all is.

This is _still_ uglier than what we already have, which is to just have 
the code call "[compat_]ptrace_request()" for any cases they don't 
recognize.

I wanted to know if there was some actual technical point to it, and never 
got a reply to that. 

			Linus
