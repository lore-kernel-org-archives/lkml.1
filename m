Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbYJJM4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbYJJM4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 08:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbYJJMz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 08:55:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:20406 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbYJJMzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 08:55:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TG9fZkECda7idYbwXyyQSiaH6jdjR+Kl2zDjNFbUB/qPTAPCQhSHqwmPZ0WvBtF80i
         JVfnSDTRGfqVQIg/06I+5Ek87FyuaPoixOuFybM+CVusmWRgKHLfleUF4vzaClyqn3i3
         hFaZ71QCyDtI6N2c1+PSBIsRvFq5a5DL9Uj6s=
Date: Fri, 10 Oct 2008 08:54:34 -0400
From: Josh Boyer <jwboyer@gmail.com>
To: Alan Cox <alan@redhat.com>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH 22/27] serial: Make uart_port's ioport "unsigned long".
Message-ID: <20081010125434.GB8590@yoda.jdub.homelinux.org>
References: <20081010103447.31597.42992.stgit@localhost.localdomain> <20081010105052.31597.41476.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010105052.31597.41476.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 11:50:56AM +0100, Alan Cox wrote:
>From: David Miller <davem@davemloft.net>
>
>Otherwise the top 32-bits of the resource value get chopped
>off on 64-bit systems, and the resulting I/O accesses go to
>random places.
>
>Thanks to testing and debugging by Josip Rodin, which helped
>track this down.
>
>Signed-off-by: David S. Miller <davem@davemloft.net>
>Signed-off-by: Alan Cox <alan@redhat.com>

I emailed on an earlier posting of this about using resource_size_t
instead as we have 32-bit CPUs with 64-bit address spaces.  If I'm
totally wrong, that's fine but I'm still wondering if that would be
a better general solution.

josh
