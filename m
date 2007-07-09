Return-Path: <linux-kernel-owner+w=401wt.eu-S1760600AbXGIVAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbXGIVAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 17:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbXGIVAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 17:00:07 -0400
Received: from dvhart.com ([64.146.134.43]:43675 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758395AbXGIVAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 17:00:03 -0400
Message-ID: <4692A1D0.50308@mbligh.org>
Date: Mon, 09 Jul 2007 14:00:00 -0700
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 00/10] [RFC] SLUB patches for more functionality, performance
 and maintenance
References: <20070708034952.022985379@sgi.com> <p73y7hrywel.fsf@bingen.suse.de> <Pine.LNX.4.64.0707090845520.13792@schroedinger.engr.sgi.com> <46925B5D.8000507@google.com> <Pine.LNX.4.64.0707091055090.16207@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0707091055090.16207@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Mon, 9 Jul 2007, Martin Bligh wrote:
> 
>> Those numbers came from Mathieu Desnoyers (LTTng) if you
>> want more details.
> 
> Okay the source for these numbers is in his paper for the OLS 2006: Volume 
> 1 page 208-209? I do not see the exact number that you referred to there.

Nope, he was a direct co-author on the paper, was
working here, and measured it.

> He seems to be comparing spinlock acquire / release vs. cmpxchg. So I 
> guess you got your material from somewhere else?
> 
> Also the cmpxchg used there is the lockless variant. cmpxchg 29 cycles w/o 
> lock prefix and 112 with lock prefix.
> 
> I see you reference another paper by Desnoyers: 
> http://tree.celinuxforum.org/CelfPubWiki/ELC2006Presentations?action=AttachFile&do=get&target=celf2006-desnoyers.pdf
> 
> I do not see anything relevant there. Where did those numbers come from?
> 
> The lockless cmpxchg is certainly an interesting idea. Certain for some 
> platforms I could disable preempt and then do a lockless cmpxchg.

Matheiu, can you give some more details? Obviously the exact numbers
will vary by archicture, machine size, etc, but it's a good point
for discussion.

M.
