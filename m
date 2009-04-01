Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbZDAWnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbZDAWnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbZDAWnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:43:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57621 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbZDAWm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:42:59 -0400
Message-ID: <49D3EDEA.4090803@zytor.com>
Date: Wed, 01 Apr 2009 15:42:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andreas Robinson <andr345@gmail.com>
CC: Alain Knaff <alain@knaff.lu>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 1/2] lib: add fast lzo decompressor
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>	 <1238593252-3435-2-git-send-email-andr345@gmail.com>	 <49D3927A.2050406@zytor.com> <1238613730.10514.35.camel@andreas-desktop>	 <49D3D4C0.1080506@zytor.com> <1238624827.15230.58.camel@andreas-desktop>
In-Reply-To: <1238624827.15230.58.camel@andreas-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Robinson wrote:
> Anyway, I assume it is maintainability rather than size you're concerned
> about here?

Right, of course.

> OTOH, the safe version is far from useless. 
> 
> I estimate (but haven't tested yet) that you would lose about 40 ms in
> the Eee test case. That is, the boot-time savings are reduced from 123
> to perhaps 85 ms which is still acceptable. It is certainly much less
> complicated than the alternatives, so if that's what you would prefer I
> can go that way.

I think if the cost is 40 ms once during boot on a slow platform, it's 
worth unifying the two codebases.  I am *not* saying that I don't think 
boot performance matters -- far be from it -- but I think this is 
probably worth the reliability and maintainability advantages of having 
a single piece of code if at all possible.

Of course, if you can figure out how to avoid that and still have the 
code clean, then that's another matter.

[Cc: Arjan, fast boot evangelizer. ;)]

	-hpa
