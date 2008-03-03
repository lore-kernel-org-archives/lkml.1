Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbYCCUmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbYCCUmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYCCUl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:41:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:23194 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbYCCUl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:41:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=X8iJxOhs04EsDBypEMS6ofkqwOLUaDrVBFps88o539AyD/FUKYttIKR1p5ZrxeygnMRpd1RpqLYpLfUWuT9jVFAAti7jdfsqXPstfQkEGHGyEm4aGl7lihZ3/+Y778UCiK8AZ9rRdoLLp9WONQvB8rTv+c4rMLNwZ5pGP9463i8=
Message-ID: <84144f020803031241l277aa3b8h2fe0714f5765cb49@mail.gmail.com>
Date: Mon, 3 Mar 2008 22:41:57 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [rfc][patch 2/3] slab: introduce SMP alignment
Cc: "Christoph Lameter" <clameter@sgi.com>, netdev@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, "David Miller" <davem@davemloft.net>,
       "Eric Dumazet" <dada1@cosmosbay.com>
In-Reply-To: <20080303202411.GH8974@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080303093449.GA15091@wotan.suse.de>
	 <20080303093529.GB15091@wotan.suse.de>
	 <Pine.LNX.4.64.0803031104570.6917@schroedinger.engr.sgi.com>
	 <20080303200355.GB8974@wotan.suse.de>
	 <Pine.LNX.4.64.0803031208400.16049@schroedinger.engr.sgi.com>
	 <20080303201211.GE8974@wotan.suse.de>
	 <Pine.LNX.4.64.0803031216430.3110@schroedinger.engr.sgi.com>
	 <20080303202411.GH8974@wotan.suse.de>
X-Google-Sender-Auth: 7c176cfaa44baaad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 10:24 PM, Nick Piggin <npiggin@suse.de> wrote:
>  > Then align the objects at cacheline boundaries by providing a value for
>  > the align parameter to kmem_cache_create().
>
>  max(num_possible_cpus() > 1 ? cache_line_size() : 0, mandatory_alignment)?
>
>  Then suppose we want a CONFIG_TINY option to eliminate it?

Hmm... Can't we just fix SLAB_HWCACHE_ALIGN in SLUB to follow the
semantics of SLAB?
