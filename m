Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbYC1Mt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbYC1Mt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbYC1MtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:49:22 -0400
Received: from twin.jikos.cz ([213.151.79.26]:41188 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbYC1MtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:49:21 -0400
Date: Fri, 28 Mar 2008 13:48:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Ingo Molnar <mingo@elte.hu>
cc: Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: agpgart: when telling user you'll corrupt his data, at least do
 it at KERN_CRIT
In-Reply-To: <20080328113528.GA8077@elte.hu>
Message-ID: <Pine.LNX.4.64.0803281347210.32241@twin.jikos.cz>
References: <20080328112507.GA10774@elf.ucw.cz> <20080328113528.GA8077@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008, Ingo Molnar wrote:

> > IOMMU off means very bad stuff may happen, like data corruption on 
> > your hard drives. At least tells users this is serious...
> ouch. Please at minimum lets turn this into a panic(), but best would be 
> to trim memory in this case, hm?

Are you suggesting to panic on all 64bit machines having more than 4G RAM 
without IOMMU turned on? Why, if swiotlb can still work nicely in such 
situations?

-- 
Jiri Kosina
SUSE Labs

