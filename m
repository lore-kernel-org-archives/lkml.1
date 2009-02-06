Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbZBFQpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbZBFQpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZBFQo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:44:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:51975 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbZBFQo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:44:57 -0500
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Message-Id: <67331C84-5400-4FE5-B6FA-395F13A482F8@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Julia Lawall <julia@diku.dk>
In-Reply-To: <Pine.LNX.4.64.0902042236200.3091@ask.diku.dk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] arch/powerpc: Eliminate double sizeof
Date: Fri, 6 Feb 2009 10:44:44 -0600
References: <Pine.LNX.4.64.0902042236200.3091@ask.diku.dk>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 4, 2009, at 3:43 PM, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
>
> Taking sizeof the result of sizeof is quite strange and does not  
> seem to be
> what is wanted here.
>
> This was fixed using the following semantic patch.
> (http://www.emn.fr/x-info/coccinelle/)
>
> // <smpl>
> @@
> expression E;
> @@
>
> - sizeof (
>  sizeof (E)
> - )
>
> @@
> type T;
> @@
>
> - sizeof (
>  sizeof (T)
> - )
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
> arch/powerpc/platforms/82xx/pq2ads-pci-pic.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

applied

- k
