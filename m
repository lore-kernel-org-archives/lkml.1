Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbZEDO3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbZEDO3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbZEDO3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:29:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:13260 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbZEDO3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:29:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Iwh6XOdQJK0Cp04AWp7jVGzgUzcF6SnrEH6M1A3N6i+CfLyiUyETQus4s7yL7PSnVz
         Qm7YEEfXB30QmPoSfXEeHIA/DUC0SyDJugO1xJ3QYkOcuXBimqvS4eJR2QkvKoIgJ1Ed
         R2QXUHaaEvKCKp262h8NCgDUG/up+jlw0lAjc=
Date: Mon, 4 May 2009 18:29:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH -tip] mm: introduce __GFP_PANIC modifier
Message-ID: <20090504142903.GM4173@lenovo>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu> <20090504131638.GJ4173@lenovo> <alpine.DEB.1.10.0905040940490.9553@qirst.com> <20090504141256.GK4173@lenovo> <alpine.DEB.1.10.0905041011200.17937@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905041011200.17937@qirst.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Lameter - Mon, May 04, 2009 at 10:13:34AM -0400]
| On Mon, 4 May 2009, Cyrill Gorcunov wrote:
| 
| > As I see page allocator already quite modified in -mm tree.
| > Christoph will kmalloc with (__GFP_NOFAIL | __GFP_REPEAT)
| > inform us on exhausted memory? Or we just stuck with blank
| > screen instead (not blank actually but with previous messages)?
| 
| If you do not specify __GFP_NOWARN then it should give you messages,
| 
| Guess we need to very that it behaves in the right wya.
|

thanks Christoph, I need to read a modified version (which
is in -mm tree now). Maybe we could find a way indeed :)

	-- Cyrill
