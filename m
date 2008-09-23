Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbYIWGGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbYIWGGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 02:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYIWGGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 02:06:39 -0400
Received: from tundra.namei.org ([65.99.196.166]:35544 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbYIWGGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 02:06:38 -0400
Date: Tue, 23 Sep 2008 16:06:35 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Toshiharu Harada <haradats@nttdata.co.jp>
Subject: Re: [PATCH] Introduce new LSM hooks where vfsmount is available.
In-Reply-To: <48D06865.8070602@nttdata.co.jp>
Message-ID: <alpine.LRH.1.10.0809231604040.25628@tundra.namei.org>
References: <48C65E9D.3070106@nttdata.co.jp> <5fb14edc0809090902m32431bf6yf518a457e410764d@mail.gmail.com> <20080910134540.45ec1272.akpm@linux-foundation.org> <48C877DE.4040402@nttdata.co.jp> <48D06865.8070602@nttdata.co.jp>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008, Kentaro Takeda wrote:

> TOMOYO Linux needs method for calculating pathname in LSM module.
> However, we have received comment from Al Viro, the vfs maintainer,
> that adding vfsmount parameter to vfs helper functions (and LSM hooks)
> is not preferable. We have asked some people (including Al), and we
> came back to the most straightforward approach; adding new LSM hooks
> where vfsmount is available.
> 
> The attached patch introduces several new LSM hooks TOMOYO Linux
> needs. It has less impact to existing LSM module and no impact to vfs
> helper functions. Please review it.

I don't see any technical errors in this patch.

If it is going to be merged, please make a new config option for 
path-based hooks (similar to that for the network hooks), so they can be 
compiled out.


- James
-- 
James Morris
<jmorris@namei.org>
