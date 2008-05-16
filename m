Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbYEPG5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbYEPG5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 02:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYEPG5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 02:57:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:21711 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYEPG5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 02:57:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=XLXc5HGdJAfdZw+sNvOyO9iKh8eauVoaHAJPJ43pyt+Bw7LGoHTEjDvBW6nrdlfAyKuO1pVjsDtolzCFIIUhFbsGBgEbsJ1bua9Bj8biQk5HK4eiXnrY8mJPgbPl2LqaNFFPDV1O6EKP9ejhc64MC1n+aI+azi83yqtdO0ElHxY=
Date: Fri, 16 May 2008 07:01:02 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Kingsley Foreman <kingsley@internode.com.au>
Cc: Patrick McHardy <kaber@trash.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NET_SCHED cbq dropping too many packets on a bonding interface
Message-ID: <20080516070102.GB3992@ff.dom.local>
References: <20080515091216.GA6550@ff.dom.local> <8ECDBB4EB5394859BFFACAAEE3A6EDB0@uglypunk> <482C6040.9030808@trash.net> <20080515182504.GB2936@ami.dom.local> <482C81CC.7000305@trash.net> <20080515184646.GC2936@ami.dom.local> <1A70765F4B30462EB21A3B3A8A442633@uglypunk> <20080516054959.GA3918@ff.dom.local> <05be01c8b71b$cbb0c9e0$f903a33a@SABINE>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05be01c8b71b$cbb0c9e0$f903a33a@SABINE>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 03:42:18PM +0930, Kingsley Foreman wrote:
...
> ok after some playing a bit if i use
>
> tc qdisc change dev bond0 parent 1: pfifo limit 30
>
> the dropped packets go away, im not sure if that is considered normal or  
> not, however any number under 30 gives me issues.

If there are no significant differences in configs between these 2.6.22
and 2.6.24/25 (e.g. things mentionned earlier by Eric) IMHO it's "more
than normal", but as I've written it would need a lot of your time and
work to check the rason.

Jarek P.
