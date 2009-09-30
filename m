Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbZI3XJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbZI3XJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZI3XJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:09:19 -0400
Received: from mail.perches.com ([173.55.12.10]:1523 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbZI3XJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:09:18 -0400
Subject: Re: [PATCH 1/2] net/netfilter/ipvs: Move #define KMSG_COMPONENT to
 Makefile
From: Joe Perches <joe@perches.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
       Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
       netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       lvs-devel@vger.kernel.org
In-Reply-To: <alpine.LSU.2.00.0910010042540.782@obet.zrqbmnf.qr>
References: <cover.1254349374.git.joe@perches.com>
	 <0026bcf5aad9ae5036e68fc2dcda9c778d30dc47.1254349375.git.joe@perches.com>
	 <alpine.LSU.2.00.0910010042540.782@obet.zrqbmnf.qr>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Sep 2009 16:09:20 -0700
Message-Id: <1254352160.2960.119.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 00:46 +0200, Jan Engelhardt wrote:
> On Thursday 2009-10-01 00:37, Joe Perches wrote:
> >This centralizes the definition and removes the
> >replicated #defines from all files
> And increases the length of the command line. Not that Linux does not
> support long command lines (in fact, configure often determines huge
> possible values on the max length test), but sometimes, developers
> have to inspect the command lines anyway for bugs, or something. It
> is already pretty long due to all the compiler flags.

Hi Jan.

I think this increased command line length hardly matters.

I think a reasonable complaint might be that it separates
the definition of a macro from the code.  I think it's
similar to the already used KBUILD_MODNAME macro though.

> How about an #include file for the ipvs private things?

It's not just IPVS, this style could be used treewide
without requiring extra #includes.

cheers, Joe

