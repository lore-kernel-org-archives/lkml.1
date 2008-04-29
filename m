Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbYD2IGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbYD2IGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 04:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYD2IGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 04:06:03 -0400
Received: from rv-out-0708.google.com ([209.85.198.242]:6800 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751411AbYD2IGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 04:06:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type:from;
        b=k7sYfNqY4EmXIlvCaH6aiFKdNetBdROY0piQLSZEMVG7/Vu7ZRt4HdrK7hsDNVSV3jVuGh0gpfPugYgeTkIE9ynJoineCwRsojPPb4LFHaQBQe4BwN3rUrDnBpIX4wLUF+IMu3nAnLCSorN4Db89PpOCZUBwNHf2+aUuMeH25j0=
Date: Tue, 29 Apr 2008 16:04:56 +0800 (CST)
X-X-Sender: wangcong@localhost.localdomain
To: Jeff Dike <jdike@addtoit.com>
cc: WANG Cong <xiyou.wangcong@gmail.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 6/19] UML - hppfs fixes
In-Reply-To: <20080428152940.GA7465@c2.user-mode-linux.org>
Message-ID: <alpine.LFD.1.00.0804291604380.2548@localhost.localdomain>
References: <20080425175608.GA11182@c2.user-mode-linux.org> <20080426.163132.194697674.xiyou.wangcong@gmail.com> <20080428152940.GA7465@c2.user-mode-linux.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
From: WANG Cong <xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Jeff Dike wrote:

> On Sat, Apr 26, 2008 at 04:31:32PM +0800, WANG Cong wrote:
>> > +		rem = copy_to_user(buf, &data->contents[off], count);
>> > +		*ppos += count - rem;
>> > +		if (rem > 0)
>> > +			return -EFAULT;
>> 
>> Could you please explain why check 'rem' after using it here?
>
> Actually, this isn't as wrong as it looks. copy_to_user returns what
> hasn't been copied (rem == remaining).  So, I think the mistake is to
> return -EFAULT here.  Returning the short count would be right, unless
> rem == count, in which case we return -EFAULT.

Yes, thanks.

--
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.
