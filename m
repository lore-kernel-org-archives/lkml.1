Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZEDONV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZEDONV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZEDOND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:13:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:10315 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbZEDONB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:13:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VgIXcrhR81EsSGZTdbIeQxw0Pr6zJ/IL8oShMsogyWRdxfhPInaqL10cmVwgS0c8Sw
         pkn+VnTo6B30SfAghyv3jY4f8xxEIbmAAU+ngrvqgdPQanfmtX09aPox3kNYIudP2143
         aNrlkXNCR+x0hP9oWbK9nIKglpuZADpM2Qfx4=
Date: Mon, 4 May 2009 18:12:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH -tip] mm: introduce __GFP_PANIC modifier
Message-ID: <20090504141256.GK4173@lenovo>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu> <20090504131638.GJ4173@lenovo> <alpine.DEB.1.10.0905040940490.9553@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905040940490.9553@qirst.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Lameter - Mon, May 04, 2009 at 09:47:45AM -0400]
| 
| 
| Could you try to avoid consuming another GFP flag? __GFP_BITS_SHIFT is
| used elsewhere to figure out where to put miscellanous flags into the gfp
| mask. This is pretty limited right now and so the patch does work.
| 
| But maybe we can combine some flags __GFP_NOFAIL | __GFP_REPEAT or so?
| 
| __GFP_NOFAIL already has the semantics that the allocation cannot fail and
| that the page allocator must never return NULL.
| 
| 

As I see page allocator already quite modified in -mm tree.
Christoph will kmalloc with (__GFP_NOFAIL | __GFP_REPEAT)
inform us on exhausted memory? Or we just stuck with blank
screen instead (not blank actually but with previous messages)?

	-- Cyrill
