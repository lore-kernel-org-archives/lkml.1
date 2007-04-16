Return-Path: <linux-kernel-owner+w=401wt.eu-S1030721AbXDPOwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030721AbXDPOwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbXDPOwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:52:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:62274 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbXDPOws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:52:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HlFCLPJc9I7PVI1Ih6FfRlS5tFOaEfr2UmzhQsBY+iNp3RE2FjCtTuQtxi7F6z2RCq4/4GL1BTyNitsRRfsiW3rYUfd2YM4oSI7L0uYsg8m8afaqtr1T93pEFuZNZDNwOyG0BPGv/zbQ6JI+g2gd6xbcS2LsNW4+hj+GGmWkWB8=
Message-ID: <b6a2187b0704160752u1c837f33p652c0d431b66459@mail.gmail.com>
Date: Mon, 16 Apr 2007 22:52:43 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: 4GB Physical. Less than 3GB in Linux.
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <46238936.3060501@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.wZS4ieAkOMvNOj61QiUn9aS+YeM@ifi.uio.no>
	 <46238936.3060501@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/07, Robert Hancock <hancockr@shaw.ca> wrote:
> Jeff Chua wrote:
> > I've noticed that with 4GB physical ram, I'm only see 3098000 MB on
> > the Dell 745, and 3107056MB on the IBM X60s.
> >
> > I've tested with CONFIG_HIGHMEM4G=y, CONFIG_HIGHMEM64G=y,
> > CONFIG_X86_PAE=y, but nothing makes any difference.
>
> Chipset limitation. It uses up most of the MMIO region above 3GB
> preventing RAM from being mapped there, and doesn't support remapping
> the covered RAM to above 4GB. Nothing the kernel can do about it.

Well, I guess I learned the hard way. So it's better not to buy 4GB
... it turns out to be the same as buying one with just 3GB RAM.

Thanks,
Jeff.
