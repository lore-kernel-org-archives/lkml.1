Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbYDYTgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbYDYTgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbYDYTgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 15:36:36 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36093 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753380AbYDYTgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 15:36:35 -0400
Date: Fri, 25 Apr 2008 12:36:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, David Miller <davem@davemloft.net>,
       zdenek.kabelac@gmail.com, rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, pageexec@freemail.hu,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] x86: fix text_poke
In-Reply-To: <20080425151747.GA3265@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0804251235550.6337@schroedinger.engr.sgi.com>
References: <20080425.021301.193689806.davem@davemloft.net>
 <1209343883-7991-1-git-send-email-jirislaby@gmail.com>
 <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org>
 <20080425151747.GA3265@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2008, Andi Kleen wrote:

> > And we should really add a lot more sanity checking there.
> 
> A debug mode for virt_to_page(),__pa,__va et.al. would probably make sense
> and would have caught it.
> 
> I used to have that partly in the x86-64 port with VIRTUAL_BUG_ON.

Good idea! Do you have a patch?

