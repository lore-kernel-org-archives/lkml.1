Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbYHHSTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbYHHSTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYHHSTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:19:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbYHHSTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:19:01 -0400
Date: Fri, 8 Aug 2008 11:17:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       krzysztof.h1@poczta.fm, adaplas@pol.net, akpm@linux-foundation.org
Subject: Re: 2.6.27-rc1: softcursor behaviour changed
In-Reply-To: <489C169F.9030907@eu.citrix.com>
Message-ID: <alpine.LFD.1.10.0808081116220.3462@nehalem.linux-foundation.org>
References: <20080805212004.GA1592@elf.ucw.cz> <20080807085733.GA1560@elf.ucw.cz> <489AD9C1.8020405@eu.citrix.com> <20080807220755.GA11460@elf.ucw.cz> <489C169F.9030907@eu.citrix.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Aug 2008, Stefano Stabellini wrote:
> 
> - an application wants to do X
> - I don't like X and X is not even implemented here
> - let's do Y instead!

Well, at the same time:
 - Y is the closest we can get in practice
 - Y is what we've done before (but I don't know how long)

So yeah, I think we should probably revert it.

		Linus
