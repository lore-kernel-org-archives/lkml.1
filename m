Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbXBJJv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbXBJJv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 04:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbXBJJv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 04:51:57 -0500
Received: from ns2.suse.de ([195.135.220.15]:49980 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbXBJJv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 04:51:56 -0500
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: rsc@swtch.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix quadratic behavior of shrink_dcache_parent()
References: <E1HFdnm-0006DB-00@dorka.pomaz.szeredi.hu>
	<20070209160055.bbd20c9f.akpm@linux-foundation.org>
	<ee9e417a0702091623t1ccf55b8wb05b64b9c51474a6@mail.gmail.com>
	<E1HFnsK-0007Ep-00@dorka.pomaz.szeredi.hu>
From: Andi Kleen <ak@suse.de>
Date: 10 Feb 2007 11:51:57 +0100
In-Reply-To: <E1HFnsK-0007Ep-00@dorka.pomaz.szeredi.hu>
Message-ID: <p73fy9e1e0i.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:
 
> So the second part of the problem is to somehow limit the number of
> dentries used.  Not easy...

OpenVZ has some existing work in this area to separate their virtual machines. 
I assume they will eventually submit it.

-Andi
