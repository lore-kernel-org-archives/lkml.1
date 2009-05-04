Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbZEDNQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbZEDNQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 09:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZEDNQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 09:16:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:11968 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789AbZEDNQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 09:16:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ODiuUxURPkJWqYL6oWul1XQ/JAxovaYKTnECCE+lXoUob1VPYJq6oPQkmiBOk10nxI
         llZRrofOHPt5FNkSFupsTIOcu3HAA99sX7qwlRDWQqyKY1WTUqMe9+hMBgU0dVNlZX/v
         V6uMgKtx+xL6R+VLArOxH1D00IrP/vl/iP8EM=
Date: Mon, 4 May 2009 17:16:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH -tip] mm: introduce __GFP_PANIC modifier
Message-ID: <20090504131638.GJ4173@lenovo>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504131311.GA23330@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Mon, May 04, 2009 at 03:13:11PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
| 
| > Hi,
| > 
| > here is an attempt to bring in __GFP_PANIC modifier.
| > The patch is made on top of -tip repo. I've been
| > trying to apply it in top of -mm tree but it
| > seems -tip is a bit newer, at least it already
| > has __GFP_BITS_SHIFT = 22 defined.
| 
| Please create a patch against -mm instead. The one in -tip is bumped 
| up by:
| 
|   8cd4001: kmemcheck: add hooks for the page allocator
|   e6df103: kmemcheck: add mm functions
| 
| But we dont want to mix that into your patch.
| 
| Thanks,
| 
| 	Ingo
| 

ok, will do

	-- Cyrill
