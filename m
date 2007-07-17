Return-Path: <linux-kernel-owner+w=401wt.eu-S936613AbXGQVof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936613AbXGQVof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbXGQVo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:44:26 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:41231 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbXGQVoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:44:25 -0400
Date: Wed, 18 Jul 2007 00:44:17 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: Further 2.6.23 merge plans...
Message-ID: <20070717214417.GE17168@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <adalkdl43w0.fsf@cisco.com> <adahco943ip.fsf@cisco.com>
	<adazm1urji8.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adazm1urji8.fsf@cisco.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Roland Dreier <rdreier@cisco.com>:
> Subject: Re: Further 2.6.23 merge plans...
> 
>  >  - Take a look at Sean's local SA caching patches.  I merged
>  >    everything else from Sean's tree, but I'm still undecided about
>  >    these.  I haven't read them carefully yet, but even aside from that
>  >    I don't have a good feeling about whether there's consensus about
>  >    this yet.  Any opinions about merging, for or against, would be
>  >    appreciated here.
> 
> Does anyone other than Sean have an opinion here?  If you want this
> feature, if you've tested it, if you don't think it's ready yet,
> whatever, please speak up -- I don't feel comfortable making a
> decision on my own here (although I will if I have to).

We have the patches applied in ofed 1.2.c with default module parameter set to
caching disabled (ofed 1.2 had a different version of the patches, but caching
is disabled by default there, too). At least in this configuration
(caching disabled), all issues I've seen seem to be fixed now, and tests seem to
be running smoothly.

So I think it's safe to merge it up if the module parameter
is set to cache disabled by default.
No idea what happens if it's enabled though :)

-- 
MST
