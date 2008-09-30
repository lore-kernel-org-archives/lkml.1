Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYI3CXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYI3CXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 22:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYI3CXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 22:23:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538AbYI3CXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 22:23:45 -0400
Date: Mon, 29 Sep 2008 19:23:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Dave Airlie <airlied@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: Linux 2.6.27-rc8
In-Reply-To: <20080929190612.111f16ac@infradead.org>
Message-ID: <alpine.LFD.2.00.0809291921310.3389@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org> <Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz> <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org> <21d7e9970809291859s5bff81e3ue0f63402c2ad422d@mail.gmail.com>
 <20080929190612.111f16ac@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Sep 2008, Arjan van de Ven wrote:
> 
> we have a patch to save/restore now, in final testing stages
> (obviously we want to be really careful with this)

Btw, the _real_ bug is clearly in the hardware design that allows you to 
brick those things without apparently even having a lock bit.

I'm hoping Intel doesn't treat this as just a software bug. Some hw 
designer should be thinking hard about which orifice they put their head 
up in.

It used to be that you could fry some monitors by feeding them 
out-of-range signals. The _monitors_ got fixed. 

		Linus
