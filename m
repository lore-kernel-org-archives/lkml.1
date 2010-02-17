Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab0BQUXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:23:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35268 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab0BQUXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:23:16 -0500
Date: Wed, 17 Feb 2010 21:23:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Extended error reporting to user space?
Message-ID: <20100217202312.GQ21783@one.firstfloor.org>
References: <201002161520.26700@zigzag.lvk.cs.msu.su> <87r5ok5gl2.fsf@basil.nowhere.org> <201002171316.49165@zigzag.lvk.cs.msu.su> <20100217103504.GO21783@one.firstfloor.org> <20100217192058.GA8937@gallifrey>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100217192058.GA8937@gallifrey>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd wondered about some form of halfway house where the error
> value is expanded but could be truncated for compatibility - i.e.

Who would do the truncation?

> if at the moment we had:
> 
>     return -EINVAL;
> 
> it would become:
> 
>     return ERRORNUM(EINVAL, BADLENGTH);

x86 only has about 12 bits in the current ABI btw.

-Andi
