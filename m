Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbYI1Uuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbYI1Uuy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 16:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYI1Uuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 16:50:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130AbYI1Uuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 16:50:46 -0400
Date: Sun, 28 Sep 2008 13:50:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Alexey Dobriyan <adobriyan@gmail.com>, ebiederm@xmission.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc7-sha1: EIP at proc_sys_compare+0x36/0x50
In-Reply-To: <alpine.LFD.1.10.0809281338350.3265@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809281349130.3265@nehalem.linux-foundation.org>
References: <20080926152031.GA30831@x200.localdomain> <alpine.LFD.1.10.0809260838120.3265@nehalem.linux-foundation.org> <20080928141856.GG28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0809281338350.3265@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 28 Sep 2008, Linus Torvalds wrote:
> 
> I dunno. Do we want to move the D_UNHASHED check up earlier? Or am I still 
> missing something?

Oh, it's not D_UNHASHED, it's DCACHE_UNHASHED. Whatever. The patch still 
looks fine, I had just forgotten the naming of the d_flags fields.

		Linus
