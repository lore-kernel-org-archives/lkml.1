Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbYHHS0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbYHHS0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYHHS02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:26:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbYHHS01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:26:27 -0400
Date: Fri, 8 Aug 2008 11:25:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Benny Halevy <bhalevy@panasas.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>, neilb@suse.de,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] uninline nfsd4_op_name()
In-Reply-To: <20080808162642.GG14495@cs181140183.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0808081120570.3462@nehalem.linux-foundation.org>
References: <20080808162642.GG14495@cs181140183.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Aug 2008, Adrian Bunk wrote:
>
> There doesn't seem to be a compelling reason why nfsd4_op_name() is 
> marked as "inline":

It should also return a "const char *", I think.

Since it does.

		Linus
