Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbZBFJnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbZBFJnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZBFJnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:43:01 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:45213 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbZBFJnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:43:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kxvwYh/Q2J8hzUVxJ3adSjhxJdXKB6qZglWUX3R5QOJGv/CIF6YGFZOklNUt6V04lt
         WivCg5vtmOQlHWEC5WGrFLu36v+Zb57nwdbBtp7pyJVIZm7aC5N2SRuNkmOecOlOFWNr
         ImMkFm0ApQdf9Kt5Gd5k9Hsn11f9agmRnmKHQ=
Date: Fri, 6 Feb 2009 09:42:53 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, zbr@ioremap.net, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090206094253.GB4879@ff.dom.local>
References: <20090203094108.GA4639@ff.dom.local> <20090205.235258.257422341.davem@davemloft.net> <20090206091034.GA4879@ff.dom.local> <20090206.011722.41272682.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206.011722.41272682.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 01:17:22AM -0800, David Miller wrote:
...
> And all I'm saying is that since the page allocator provides that
> facility, and using pages solves all of the splice() et al.  problems,
> building something extremely simple on top of the page allocator seems
> to be a good way to go.

This all is absolutely right if we can afford it: more simple - more
memory wasted. I hope you're right, but on the other hand, people
don't use slob by default.

Jarek P.
