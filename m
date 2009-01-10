Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZAJFLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZAJFLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 00:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbZAJFL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 00:11:29 -0500
Received: from ozlabs.org ([203.10.76.45]:38506 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZAJFL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 00:11:28 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] cpumask fallout: Initialize irq_default_affinity earlier.
Date: Sat, 10 Jan 2009 15:41:13 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
References: <1231446081-8448-1-git-send-email-ddaney@caviumnetworks.com> <496666CE.3050205@caviumnetworks.com> <alpine.LFD.2.00.0901081256170.3283@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901081256170.3283@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901101541.15192.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 January 2009 07:26:59 Linus Torvalds wrote:
> 
> On Thu, 8 Jan 2009, David Daney wrote:
> > 
> > The 'inline' seems gratuitous to me.  Since it is static GCC should do 
> > the Right Thing.  However since you suggested it, I am testing it that 
> > way.
> 
> Trust me, gcc very seldom does the Right Thing(tm) when it comes to 
> inlining. 
> 
> 			Linus

Note that there's a downside: with inline funcs in .c files you don't get
a warning should they become unused in future cleanups.

Cheers,
Rusty.
