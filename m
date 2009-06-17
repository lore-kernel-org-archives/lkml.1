Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbZFQATT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbZFQATT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 20:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbZFQATK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 20:19:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756731AbZFQATJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 20:19:09 -0400
Date: Tue, 16 Jun 2009 17:19:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Patterson <andrew.patterson@hp.com>
cc: linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in resources
 trees
In-Reply-To: <alpine.LFD.2.01.0906161640250.16802@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906161717220.16802@localhost.localdomain>
References: <20090616220419.14021.84524.stgit@bob.kio>  <alpine.LFD.2.01.0906161511390.16802@localhost.localdomain>  <1245192703.8234.226.camel@bluto.andrew>  <alpine.LFD.2.01.0906161556020.16802@localhost.localdomain> <1245195498.8234.236.camel@bluto.andrew>
 <alpine.LFD.2.01.0906161640250.16802@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Jun 2009, Linus Torvalds wrote:
> 
> I may also be confused, and not have found the right place that actually 
> inserts the resource.

Can you try this patch? It's simple and stupid and will be very noisy, but 
it should hopefully get a call chain for all the cases where we set 
parenthood, and then we can hopefully see exactly where that incorrect 
nesting gets done.

No guarantees, I didn't test this. But I suspect you see where I'm trying 
to go.

			Linus
