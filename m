Return-Path: <linux-kernel-owner+w=401wt.eu-S1762200AbXEJNBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762200AbXEJNBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbXEJNBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:01:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36336 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759587AbXEJNBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:01:47 -0400
Date: Thu, 10 May 2007 15:01:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: ak@suse.de, linux-kernel@vger.kernel.org, joerg.roedel@amd.com
Subject: Re: Andi, you broke my laptop :-)
Message-ID: <20070510130144.GI14898@one.firstfloor.org>
References: <20070509125616.cde56b8e.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509125616.cde56b8e.zaitcev@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 12:56:16PM -0700, Pete Zaitcev wrote:
> Hi, Andi:
> 
> The attached patch (actually, git show output) makes my Dell 1501 to hang
> on boot. Sorry, I have no clue why... The culprit is found with git bisect.
> But yes, it's an AMD MK-36. I use an x86_64 kernel. It is 100% reproducible.

MK-36? Does it have SVM? 

Anyways we previously had issues with this being miscompiled, but 
I thought the latest patch should have been ok. What compiler do you use?

Can you send me a disassembly listing of arch/x86_64/kernel/time.o?

-Andi
