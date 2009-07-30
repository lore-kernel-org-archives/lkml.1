Return-Path: <linux-kernel-owner+w=401wt.eu-S1751710AbZG3I7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbZG3I7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 04:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZG3I7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 04:59:05 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:40862 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236AbZG3I7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 04:59:04 -0400
Subject: Re: linux-next: kmemleak tree build failure
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090730160012.5814e251.sfr@canb.auug.org.au>
References: <20090730160012.5814e251.sfr@canb.auug.org.au>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 30 Jul 2009 09:58:57 +0100
Message-Id: <1248944337.3376.5.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2009 08:58:58.0289 (UTC) FILETIME=[F9860E10:01CA10F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 16:00 +1000, Stephen Rothwell wrote:
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> arch/x86/kernel/process.c: In function 'free_thread_info':
> arch/x86/kernel/process.c:58: error: implicit declaration of function 'kmemleak_free'
> 
> Caused by commit 3d898087320a732ec853c98f244253892616840f ("kmemleak:
> Inform kmemleak about kernel stack allocation") from the kmemleak tree.
> Probably a missing include of linux/kmemleak.h.

Yes, it's missing this (I was only testing it with slub which has
kmemleak.h included in its header file).

I updated the kmemleak branch now. Thanks.

-- 
Catalin

