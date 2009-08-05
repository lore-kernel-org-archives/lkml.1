Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbZHEWrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbZHEWrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 18:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZHEWrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 18:47:52 -0400
Received: from tundra.namei.org ([65.99.196.166]:49717 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbZHEWrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 18:47:51 -0400
Date: Thu, 6 Aug 2009 08:47:47 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Julia Lawall <julia@diku.dk>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/2] security/smack: Use AF_INET for sin_family field
In-Reply-To: <Pine.LNX.4.64.0908051434340.20453@pc-004.diku.dk>
Message-ID: <alpine.LRH.2.00.0908060847170.6643@tundra.namei.org>
References: <Pine.LNX.4.64.0908051434340.20453@pc-004.diku.dk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Aug 2009, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Elsewhere the sin_family field holds a value with a name of the form
> AF_..., so it seems reasonable to do so here as well.  Also the values of
> PF_INET and AF_INET are the same.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
