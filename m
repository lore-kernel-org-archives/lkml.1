Return-Path: <linux-kernel-owner+w=401wt.eu-S1760914AbZAHU5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbZAHU5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbZAHU5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:57:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515AbZAHU5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:57:12 -0500
Date: Thu, 8 Jan 2009 12:56:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Daney <ddaney@caviumnetworks.com>
cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] cpumask fallout: Initialize irq_default_affinity
 earlier.
In-Reply-To: <496666CE.3050205@caviumnetworks.com>
Message-ID: <alpine.LFD.2.00.0901081256170.3283@localhost.localdomain>
References: <1231446081-8448-1-git-send-email-ddaney@caviumnetworks.com> <alpine.LFD.2.00.0901081227360.3283@localhost.localdomain> <496666CE.3050205@caviumnetworks.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Jan 2009, David Daney wrote:
> 
> The 'inline' seems gratuitous to me.  Since it is static GCC should do 
> the Right Thing.  However since you suggested it, I am testing it that 
> way.

Trust me, gcc very seldom does the Right Thing(tm) when it comes to 
inlining. 

			Linus
