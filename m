Return-Path: <linux-kernel-owner+w=401wt.eu-S1761213AbYEHAGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761213AbYEHAGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbYEHAGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:06:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753706AbYEHAGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:06:33 -0400
Date: Wed, 7 May 2008 17:06:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Sparc
In-Reply-To: <20080507.163917.104000894.davem@davemloft.net>
Message-ID: <alpine.LFD.1.10.0805071705360.3024@woody.linux-foundation.org>
References: <20080507.163917.104000894.davem@davemloft.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, David Miller wrote:
> 
> 1) If fork/clone/etc. errors, argument register %o2 is clobbered
>    breaking syscall restart.

Wow. Do we actually restart fork/clone/etc? That sounds suspicious. Maybe 
there is some other bug here?

		Linus
