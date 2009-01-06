Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbZAFWJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbZAFWJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbZAFWJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:09:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755528AbZAFWJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:09:32 -0500
Date: Tue, 6 Jan 2009 14:08:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Chris Zankel <chris@zankel.net>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Gerd Hoffmann <kraxel@redhat.com>, bluebird <bluebird@gentoo.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/23] byteorder: only use linux/swab.h
In-Reply-To: <1231277444.964.258.camel@brick>
Message-ID: <alpine.LFD.2.00.0901061407120.3057@localhost.localdomain>
References: <1231277444.964.258.camel@brick>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Jan 2009, Harvey Harrison wrote:
>
> The first step to make swab.h a regular header that will
> include an asm/swab.h with arch overrides.

Btw, was there some reason why you didn't just do the <asm/swab.h> files 
first? That would seem to simplify the whole sequence, and in fact it 
would also allow me to just apply all the "create asm/swab.h" patches 
first regardless of any other work..

		Linus
