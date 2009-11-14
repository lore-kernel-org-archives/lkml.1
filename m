Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbZKNNVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbZKNNVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 08:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbZKNNVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 08:21:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbZKNNVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 08:21:01 -0500
Date: Sat, 14 Nov 2009 11:18:39 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: net tree build failure
Message-ID: <20091114131839.GD314@ghostprotocols.net>
References: <20091114175041.61bdb27f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091114175041.61bdb27f.sfr@canb.auug.org.au>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Nov 14, 2009 at 05:50:41PM +1100, Stephen Rothwell escreveu:
> Hi Dave,
> 
> Today's linux-next build (alpha defconfig) failed like this:
> 
> arch/alpha/kernel/systbls.S:507: Error: .err encountered
> 
> Caused by commit a2e2725541fad72416326798c2d7fa4dafb7d337 ("net:
> Introduce recvmmsg socket syscall") which added a syscall to the alpha
> syscall table but forgot to update NR_SYSCALLS in
> arch/alpha/include/asm/unistd.h (it also didn't add the __NR_ constant
> thee either).
> 
> I suspect that this is true for a few other architectures as well
> (including sparc?).

I'm trying to get hold of a cross compiler setup now...

- Arnaldo
