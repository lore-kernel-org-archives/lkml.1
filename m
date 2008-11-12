Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbYKLCYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbYKLCYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 21:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYKLCYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 21:24:32 -0500
Received: from relay1.sgi.com ([192.48.179.29]:59193 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751510AbYKLCYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 21:24:31 -0500
Message-ID: <491A3EB9.8020203@sgi.com>
Date: Tue, 11 Nov 2008 18:26:01 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Eric Dumazet <dada1@cosmosbay.com>, Takashi Iwai <tiwai@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] Allocate module.ref array dynamically
References: <s5htzaekp6o.wl%tiwai@suse.de> <491A01E2.2010701@cosmosbay.com> <200811121214.33150.rusty@rustcorp.com.au>
In-Reply-To: <200811121214.33150.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 12 November 2008 08:36:26 Eric Dumazet wrote:
>> I believe Mike Travis has a better patch for this problem, partly using new
>> percpu allocator.
> 
> Actually, I think this in in Christoph's hands now.  He's been wrangling with 
> getting us a real per-cpu allocator.
> 
> There's something in linux-next, but I'm not sure of the status. Christoph, is 
> this anticipated to make the next merge window, or am I best off merging a 
> patch like Eric's for the moment?
> 
> Thanks,
> Rusty.


I haven't looked closely at Christoph's latest but I believe the x86_64 version
is waiting for the zero-based percpu variables (and hence the combined pda/percpu
base.)  It's on the queue just under 4k cpus.

Cheers,
Mike
