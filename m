Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbYKLDPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbYKLDPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 22:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbYKLDPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 22:15:33 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:38910 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYKLDPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 22:15:32 -0500
Date: Tue, 11 Nov 2008 21:14:51 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Eric Dumazet <dada1@cosmosbay.com>, Takashi Iwai <tiwai@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] Allocate module.ref array dynamically
In-Reply-To: <200811121214.33150.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0811112113001.10592@quilx.com>
References: <s5htzaekp6o.wl%tiwai@suse.de> <491A01E2.2010701@cosmosbay.com>
 <200811121214.33150.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008, Rusty Russell wrote:

> On Wednesday 12 November 2008 08:36:26 Eric Dumazet wrote:
> > I believe Mike Travis has a better patch for this problem, partly using new
> > percpu allocator.
>
> Actually, I think this in in Christoph's hands now.  He's been wrangling with
> getting us a real per-cpu allocator.

Please use my new email address.... Otherwise I will not see this.

> There's something in linux-next, but I'm not sure of the status. Christoph, is
> this anticipated to make the next merge window, or am I best off merging a
> patch like Eric's for the moment?

Yes the patch in -next is for the next merge window. This should
actually have been in .28.

