Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbZJFSf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbZJFSf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933106AbZJFSf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:35:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933105AbZJFSf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:35:58 -0400
Date: Tue, 6 Oct 2009 11:35:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frans Pop <elendil@planet.nl>
cc: mingo@elte.hu, hohndel@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <200910061840.57681.elendil@planet.nl>
Message-ID: <alpine.LFD.2.01.0910061132150.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <200910061840.57681.elendil@planet.nl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, Frans Pop wrote:
> 
> Enabling it by default somehow would be fine with me, but "compulsory" is a 
> step to far IMO. Users should always be allowed custom schemes.

I do respect that - we shouldn't _force_ things if some people have 
special needs and do things differently and really need a very particular 
version number setup.

That said, we might make it a lot harder for people to overlook this by 
mistake when they don't care or know enough. Maybe we can have three 
levels of the "automatic" version number, and make the third level ("no 
automatic sign of versioning at all") be something that you really need to 
ask for (eg you need to have EMBEDDED enabled to show that you want the 
whole extended config option setup or something fairly draconian like 
that).

				Linus
