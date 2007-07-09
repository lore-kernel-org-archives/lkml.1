Return-Path: <linux-kernel-owner+w=401wt.eu-S1759248AbXGISMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbXGISMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbXGISMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:12:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58062 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753600AbXGISMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:12:37 -0400
Date: Mon, 9 Jul 2007 11:11:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Martin Bligh <mbligh@google.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch 00/10] [RFC] SLUB patches for more functionality,
 performance and maintenance
In-Reply-To: <46925B5D.8000507@google.com>
Message-ID: <Pine.LNX.4.64.0707091055090.16207@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com> <p73y7hrywel.fsf@bingen.suse.de>
 <Pine.LNX.4.64.0707090845520.13792@schroedinger.engr.sgi.com>
 <46925B5D.8000507@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Martin Bligh wrote:

> Those numbers came from Mathieu Desnoyers (LTTng) if you
> want more details.

Okay the source for these numbers is in his paper for the OLS 2006: Volume 
1 page 208-209? I do not see the exact number that you referred to there.

He seems to be comparing spinlock acquire / release vs. cmpxchg. So I 
guess you got your material from somewhere else?

Also the cmpxchg used there is the lockless variant. cmpxchg 29 cycles w/o 
lock prefix and 112 with lock prefix.

I see you reference another paper by Desnoyers: 
http://tree.celinuxforum.org/CelfPubWiki/ELC2006Presentations?action=AttachFile&do=get&target=celf2006-desnoyers.pdf

I do not see anything relevant there. Where did those numbers come from?

The lockless cmpxchg is certainly an interesting idea. Certain for some 
platforms I could disable preempt and then do a lockless cmpxchg.
