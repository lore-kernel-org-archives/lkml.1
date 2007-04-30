Return-Path: <linux-kernel-owner+w=401wt.eu-S1423178AbXD3JJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423178AbXD3JJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 05:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423179AbXD3JJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 05:09:21 -0400
Received: from ns2.suse.de ([195.135.220.15]:38817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423178AbXD3JJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 05:09:01 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [patches] [PATCH] [8/35] x86_64: a memcpy that tries to reducecache pressure
Date: Mon, 30 Apr 2007 11:04:26 +0200
User-Agent: KMail/1.9.6
Cc: "Bryan O'Sullivan" <bos@pathscale.com>,
       "Roland Dreier" <rolandd@cisco.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
References: <20070428752.712152000@suse.de> <20070428175232.5A688151CA@wotan.suse.de> <4635B62D.76E4.0078.0@novell.com>
In-Reply-To: <4635B62D.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301104.26478.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 April 2007 09:26:05 Jan Beulich wrote:
> >+	testb	$8, %dxl	/* rdx is 3,5,6,7,9..15 */
> 
> Could you use the more conventional name %dl (or whatever is being meant)
> here?
> 
> >+.L42:
> >+	prefetchnta	128(%rsi)
> 
> I think I commented similarly on a previous version of the patch: This will 
> - result in still bringing the first 128 bytes into the cache
> - prevent caching of memory beyond the buffer being dealt with

Yes I remember, somehow it got lost. I agree it's a bad thing. Will drop
the patch for now especially since nothing seems to really need it right now.

Thanks,

-Andi
