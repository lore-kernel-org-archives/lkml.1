Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab0BKNde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 08:33:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:42682 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab0BKNdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 08:33:33 -0500
Message-ID: <4B7408D4.9070808@kernel.org>
Date: Thu, 11 Feb 2010 22:40:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> <E1NfVho-0002nJ-V2@pomaz-ex.szeredi.hu> <4B73F006.7090706@kernel.org> <E1NfY6X-00032f-42@pomaz-ex.szeredi.hu> <4B73FCF2.3020108@kernel.org> <E1NfYRH-00035s-4h@pomaz-ex.szeredi.hu> <4B7400A7.5070105@kernel.org> <E1NfYmD-0003Aj-N9@pomaz-ex.szeredi.hu>
In-Reply-To: <E1NfYmD-0003Aj-N9@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Feb 2010 13:33:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/11/2010 10:08 PM, Miklos Szeredi wrote:
> No, I don't want to pass file descriptors (early fuse did use that for
> readdir and it was a mistake).

Yeah, I agree that passing fds is pretty painful to implement and look
at.

> Global address space for server side maps are OK.

Do you mean having single dmmap AS is okay?

> What I mind is that in the *absence* of server side maps the
> filesystem still has to deal with the global address space (with all
> its quirks).  This is totally unnecessary.

And then the above seems contradictory with the first sentence.  Sorry
to be dense but I really don't follow what you're suggesting.  If
you're okay with single dmmap AS, how can you not be okay with the
quirks of dealing with global AS?  The only exit from that problem is
having multiple ASes.

Thanks.

-- 
tejun
