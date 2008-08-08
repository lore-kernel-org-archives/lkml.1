Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbYHHPIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbYHHPIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 11:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYHHPIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 11:08:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:8037 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbYHHPIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 11:08:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FGiYqmLHOuUG6EOdtyx5Ch0rkkul4IW6Pc2XdnNdG0AAHzONwu8VKQVSWhwKBMoTLN
         IKs2L36/cfNY6NmKYXn3suobsC7crhEIclpuOesZsCtj6NyogHxq1UKliw41WDyeAx0H
         Anq+OvhXQv+r2Ozt0DtwBjvLBbg61B8v8Pzcs=
Date: Fri, 8 Aug 2008 18:08:26 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org,
       netdev@vger.kernel.org, haoki@redhat.com
Subject: Re: possible recursive locking in udp4_lib_rcv
Message-ID: <20080808150825.GA18199@google.com>
References: <20080807234613.GA9598@google.com> <E1KRSxN-0005Ng-00@gondolin.me.apana.org.au> <20080808143741.GA20777@gondor.apana.org.au> <20080808150108.GA21048@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808150108.GA21048@gondor.apana.org.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 11:01:08PM +0800, Herbert Xu wrote:
> On Fri, Aug 08, 2008 at 10:37:41PM +0800, Herbert Xu wrote:
> >
> > Never mind, I see the reason why it's there.  What we should do
> > is drop the lock when we hit an encapsulated socket since they
> > don't need it at all.
> 
> Here is the patch:

Nice. Open a bugzilla entry for this?
