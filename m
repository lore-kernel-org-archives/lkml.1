Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbYAPWkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbYAPWkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbYAPWjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:39:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:31909 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbYAPWj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:39:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=atdzBESoODiFI8xSsYpU4AxIvlPGICk5DrzzQFr5yGoUrMHQ9bqD1JrMwsUJw8OKZ17E9Owm601w2GqLZ63PjMF3NCoYcjFt3q3a2ISudMbFPkb1w0TsA+ytZL3UFaf0szzg2S5yY10IjHrXZg1LYrTM6ocVYECPNtIA++qe77Q=
Date: Wed, 16 Jan 2008 23:42:44 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, cfriesen@nortel.com,
       davem@davemloft.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network
	packets
Message-ID: <20080116224244.GA2626@ami.dom.local>
References: <20080115202905.GA2680@ami.dom.local> <E1JEvxs-0006cZ-00@gondolin.me.apana.org.au> <20080116065836.GA1638@ff.dom.local> <20080116200458.GC8953@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116200458.GC8953@1wt.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 09:04:58PM +0100, Willy Tarreau wrote:
...
> you can work with latest release provided that you always have a fallback
> to an earlier one. That way, you don't bet too much on something you don't
> completely control. If it works, it tells you you'll be able to completely
> exploit its new possibilities in next product release, and if it breaks,
> it's easy to issue a fix to get back to earlier, well-tested version.

Of course, this way looks preferable, but sometimes maybe too costly,
especially with some complex systems. Actually, I don't even think
this have to be fully (production ready) implemented or workable.
Probably there would be even enough to maintain some simplified kind
of test checking how current kernel changes could affect such a system,
and how new versions of this system are better, BTW.

Regards,
Jarek P.
