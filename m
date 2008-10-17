Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbYJQVqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbYJQVqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 17:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYJQVqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 17:46:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:51999 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbYJQVqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 17:46:44 -0400
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.2.00.0810171410020.3438@nehalem.linux-foundation.org>
References: <adatzbbap8a.fsf@cisco.com> <1224214314.7654.65.camel@pasglop>
	 <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>
	 <20081016.210404.151891223.davem@davemloft.net>
	 <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>
	 <1224220339.7654.84.camel@pasglop>
	 <alpine.LFD.2.00.0810170852010.3438@nehalem.linux-foundation.org>
	 <1224277413.7654.95.camel@pasglop>
	 <alpine.LFD.2.00.0810171410020.3438@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 18 Oct 2008 08:45:47 +1100
Message-Id: <1224279947.7654.106.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-17 at 14:11 -0700, Linus Torvalds wrote:

> So the default is all the wrong way around. Make the defaults the sane 
> ones: 04x for IO, and 08x for MMIO, and then see if anybody wants anything 
> else. I seriously doubt they do. The whole ".. but but sparc" argument 
> seems to be entirely based on the total mis-conception of truncation that 
> has no relevance.

Well, I definitely want 08x for IO on powerpc and I suspect anything
non-x86 or alpha does as well... So I'm fine but I'd like to keep
the default for IO at 08x unless you really have a strong opinion
against it.

Cheers,
Ben.


