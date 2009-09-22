Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbZIVXzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbZIVXzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 19:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbZIVXzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 19:55:39 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:48203 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbZIVXzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 19:55:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VH2LPMox9cPIuEulaei3gi0w/M7WNca7IdzhY5IZ32O/3foVnKHfmJkv3UAGRdn41y
         NavoTpuYL3ZHAASulQ5jtfe/SGhvfOwrhLWE/gSbfR5aE1STdRBEakhGVpdbaplBS7dX
         JiuBzqy4kFPquRk0hrNrNhw00MdhLg3BVRsMY=
Date: Wed, 23 Sep 2009 03:55:34 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: avorontsov@ru.mvista.com, Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>, ben@fluff.org,
       grant.likely@secretlab.ca, benh@kernel.crashing.org, khali@linux-fr.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/6] mtd: m25p80: Convert to device table matching
Message-ID: <20090922235534.GA3796@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090731003957.GA23982@oksana.dev.rtsoft.ru>
 <20090731004100.GB8371@oksana.dev.rtsoft.ru>
 <200908031954.50955.david-b@pacbell.net>
 <20090922141705.b5d31e24.akpm@linux-foundation.org>
 <20090922230150.GA27593@oksana.dev.rtsoft.ru>
 <1253663027.27055.528.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1253663027.27055.528.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 04:43:47PM -0700, David Woodhouse wrote:
> On Wed, 2009-09-23 at 03:01 +0400, Anton Vorontsov wrote:
> > 
> > And the two patches I sent on top:
> > 
> > http://lkml.org/lkml/2009/8/18/364
> > http://lkml.org/lkml/2009/8/18/366
> 
> Got versions of those which apply to the mtd-2.6.git tree (which I'm
> about to ask Linus to pull)? 

I'd love to, but they depend on a bunch of SPI patches that are still
in -mm tree. As soon as SPI core changes hit Linus' tree, I think
Andrew will send all m25p80 patches to you anyway.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
