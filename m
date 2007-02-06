Return-Path: <linux-kernel-owner+w=401wt.eu-S1751831AbXBFJMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbXBFJMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbXBFJMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:12:25 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:21290 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbXBFJMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:12:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=m/cJ59v/dkkaUJMLzFAgIWk4QfzAyCYZaSYVCFN1gzjdTZLJiqnvTNZxMeY23VXZqZmXjzrj0hDkdHecP590ZW2dwGdLlhj2PZeBgK71AK3gY2FNeBrHzf+QlMxwQtCUaAvFTX4oW1CTGvgyaKuEiwbnlCVKe1AobKSLP4emazI=
Date: Tue, 6 Feb 2007 11:12:07 +0200
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: ebs@ebshome.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linuxppc-embedded@ozlabs.org
Subject: Re: [PATCH 2.6.20] ibm_emac: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206091207.GR3896@Ahmed>
References: <20070205165429.GD3896@Ahmed> <20070205165916.GK3896@Ahmed> <20070205202206.GD11055@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205202206.GD11055@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 11:22:06PM +0300, Alexey Dobriyan wrote:
> On Mon, Feb 05, 2007 at 06:59:16PM +0200, Ahmed S. Darwish wrote:
> > A patch to use ARRAY_SIZE macro already defined in kernel.h.
> 
> OK, but checks you're changing are strange. idx there is signed so
> 
> 	BUG_ON(idx < 0 || idx > ARRAY_SIZE());
> 
> should be more appropriate.

It's just a janitor patch. I don't like to mess with code logic in such
kind of patches (to minimize errors and because I can't find time to
understand all affected files since they are scattered allover the tree).

Thanks,
-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
