Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbYBWNP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbYBWNP2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 08:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYBWNPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 08:15:09 -0500
Received: from mx1.suse.de ([195.135.220.2]:44820 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbYBWNPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 08:15:08 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC PATCH 0/8]: uninline & uninline
From: Andi Kleen <andi@firstfloor.org>
References: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi>
	<20080223000220.e9229c99.akpm@linux-foundation.org>
Date: Sat, 23 Feb 2008 14:15:06 +0100
In-Reply-To: <20080223000220.e9229c99.akpm@linux-foundation.org> (Andrew Morton's message of "Sat\, 23 Feb 2008 00\:02\:20 -0800")
Message-ID: <p734pbz95lx.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:


>> -41525  2066 f, 3370 +, 44895 -, diff: -41525  IS_ERR 
>
> This is a surprise.  I expect that the -mm-only
> profile-likely-unlikely-macros.patch is the cause of this and mainline
> doesn't have this problem.

Shouldn't they only have overhead when the respective CONFIG is enabled?

> If true, then this likely/unlikely bloat has probably spread into a lot of
> your other results and it all should be redone against mainline, sorry :(
>
> (I'm not aware of anyone having used profile-likely-unlikely-macros.patch
> in quite some time.  That's unfortunate because it has turned up some
> fairly flagrant code deoptimisations)

Is there any reason they couldn't just be merged to mainline? 

I think it's a useful facility.

-Andi
