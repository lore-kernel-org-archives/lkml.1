Return-Path: <linux-kernel-owner+w=401wt.eu-S1762357AbZANMan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762357AbZANMan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 07:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbZANMaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 07:30:35 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:54799 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634AbZANMae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 07:30:34 -0500
Subject: Re: [PATCH 00/14] Kernel memory leak detector
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090112213339.feefdd02.sfr@canb.auug.org.au>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	 <20090108144538.e5195575.akpm@linux-foundation.org>
	 <1231753866.10982.11.camel@pc1117.cambridge.arm.com>
	 <20090112022138.bd2e6ce4.akpm@linux-foundation.org>
	 <20090112213339.feefdd02.sfr@canb.auug.org.au>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 14 Jan 2009 12:30:20 +0000
Message-Id: <1231936220.24082.11.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jan 2009 12:30:21.0098 (UTC) FILETIME=[DDB060A0:01C97643]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Mon, 2009-01-12 at 21:33 +1100, Stephen Rothwell wrote:
> On Mon, 12 Jan 2009 02:21:38 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > The many trees in linux-next are actually based on current mainline. 
> > So if you can prepare and maintain a tree based on current mainline,
> > Stephen could integrate that into linux-next, hopefully.
> 
> That's what I'm here for :-)

I updated the git://linux-arm.org/linux-2.6.git kmemleak branch to the
latest mainline and it works fine. However, I tried to merge it with the
linux-next tree and there are many conflicts with kmemtrace as they both
modify similar areas of the kernel. The conflicts are relatively simple
but they still need manual fixing.

Are you OK with applying patches to linux-next (git am) rather than
using git merge? This way I can rebase kmemleak on top of linux-next.

Thanks.

-- 
Catalin

