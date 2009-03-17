Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbZCQQqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbZCQQqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbZCQQqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:46:35 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:46752 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbZCQQqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:46:35 -0400
Date: Tue, 17 Mar 2009 12:41:09 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nitin Gupta <ngupta@vflare.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3]: xvmalloc memory allocator
In-Reply-To: <49BF8B8B.40408@vflare.org>
Message-ID: <alpine.DEB.1.10.0903171237180.21582@qirst.com>
References: <49BF8ABC.6040805@vflare.org> <49BF8B8B.40408@vflare.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009, Nitin Gupta wrote:

> Slub allocator could not be used due to fragmentation issues:
> http://code.google.com/p/compcache/wiki/AllocatorsComparison
> Data here shows kmalloc using ~43% more memory than TLSF and xvMalloc
> is showed ~2% more space efficiency than TLSF (due to smaller metadata).

Well this looks like the use of 2^n sizes of the kmalloc arrayse cause a
lot of wastage here. Creating slab caches that fit your needs may help?
Have you had a look at the SLOB approach?
