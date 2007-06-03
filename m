Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbXFCVI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbXFCVI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 17:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbXFCVIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 17:08:51 -0400
Received: from smtp-out.google.com ([216.239.45.13]:61571 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbXFCVIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 17:08:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=S1KVzgF+9EzfhWoahuk+imStBzWUpd1U5qk5OQagR8L8u2ISBUkXk/Kql6Uuh9UdB
	dxALd3MtRFGylvpK2OyQQ==
Message-ID: <cc96a5040706031408i54116922m7a83c7e0b07181e6@mail.gmail.com>
Date: Sun, 3 Jun 2007 14:08:40 -0700
From: "Tim Hockin" <thockin@google.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: Kconfig variable "COBALT" is not defined anywhere
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <adazm3glqcr.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706031315230.23477@localhost.localdomain>
	 <20070603132309.508738b7.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0706031630030.26035@localhost.localdomain>
	 <adazm3glqcr.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There were other patches which added more COBALT support, but they
were dropped or lost or whatever.

I would not balk at having that code yanked.  I never got around to
doing proper Cobalt support for modern kernels. :(

On 6/3/07, Roland Dreier <rdreier@cisco.com> wrote:
>  > > >   there is no Kconfig file which defines the selectable option
>  > > > "COBALT", which means that this snippet from drivers/char/nvram.c:
>  > > >
>  > > > #  if defined(CONFIG_COBALT)
>  > > > #    include <linux/cobalt-nvram.h>
>  > > > #    define MACH COBALT
>  > > > #  else
>  > > > #    define MACH PC
>  > > > #  endif
>  > > > never evaluates to true, therefore making <linux/cobalt-nvram.h>
>  > > > fairly useless, at least under the circumstances.
>
>  > > Maybe it should be MIPS_COBALT ?
>
>  > that's the first thing that occurred to me, but that header file is
>  > copyright sun microsystems and says nothing about MIPS, so that didn't
>  > really settle the issue.  that's why i'd rather someone else resolve
>  > this one way or the other.
>
> Actually, looking through the old kernel history, it looks like this
> was added by Tim Hockin's (CCed) patch "Add Cobalt Networks support to
> nvram driver".  Which added this to drivers/cobalt:
>
> +bool 'Support for Cobalt Networks x86 servers' CONFIG_COBALT
>
> I guess Tim can clear up what's intended...
>
