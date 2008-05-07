Return-Path: <linux-kernel-owner+w=401wt.eu-S1765015AbYEGRc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765015AbYEGRc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763669AbYEGRa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:30:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57763 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764695AbYEGRax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:30:53 -0400
Date: Wed, 7 May 2008 10:30:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jiri Slaby <jirislaby@gmail.com>
cc: linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       pageexec@freemail.hu, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, rjw@sisk.pl, zdenek.kabelac@gmail.com,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 1/1] mm: add virt to phys debug
In-Reply-To: <4820D39E.3090109@gmail.com>
Message-ID: <Pine.LNX.4.64.0805071030180.3173@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0804281322510.31163@schroedinger.engr.sgi.com>
 <1209669740-10493-1-git-send-email-jirislaby@gmail.com>
 <Pine.LNX.4.64.0805011310390.9288@schroedinger.engr.sgi.com>
 <4820D39E.3090109@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008, Jiri Slaby wrote:

> I like the idea, I'll get back with a patch in few days (sorry, too busy).
> Anyway bounds.h should be include/asm/ thing though.

For arch specific stuff use asm-offsets.h. It would have to be included in 
page_xx.h.

 
