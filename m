Return-Path: <linux-kernel-owner+w=401wt.eu-S1423234AbXDYGhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423234AbXDYGhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423235AbXDYGhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:37:36 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:1879 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423234AbXDYGhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:37:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jQprMEJdvXoxt36p0NQfEIKoVvoXtXZvWHKMDlhkZc9FjTToEKDilnMDtroWOIF8USSxArhix/2omAlqomzS9zXEqC9bO8TLQgR9I3l/GA5KkrZsUrw4HTXkUvJVC5tYBnzWo997xXkgg5AO1KL4vG/Eql5HghJbBJmSjz8EzbM=
Message-ID: <4ac8254d0704242337m518d87c3y8a26df66632ea6e4@mail.gmail.com>
Date: Wed, 25 Apr 2007 08:37:33 +0200
From: "Tuncer Ayaz" <tuncer.ayaz@gmail.com>
To: "Cestonaro, Thilo (external)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
Subject: Re: NonExecutable Bit in 32Bit
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4ac8254d0704242333g17972a7q2106015af946ea5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF052CFB78@ABGEX01E.abg.fsc.net>
	 <Pine.LNX.4.64.0704240640470.25153@server.thyself>
	 <4ac8254d0704240046s23b2d349m2e0f0caa7eb95a91@mail.gmail.com>
	 <F7F9B0BE3E9BD449B110D0B1CEF6CAEF0530256E@ABGEX01E.abg.fsc.net>
	 <4ac8254d0704242333g17972a7q2106015af946ea5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/07, Tuncer Ayaz <tuncer.ayaz@gmail.com> wrote:
> On 4/25/07, Cestonaro, Thilo (external)
> <Thilo.Cestonaro.external@fujitsu-siemens.com> wrote:
> > Hey,
> >
> > > CONFIG_HIGHMEM64G=y
> > > CONFIG_HIGHMEM=y
> > > CONFIG_X86_PAE=y
> >
> > Ok in highmem it's active, whats about lowmem?
> > x86-64 is NX active for lowmem too AFAIK.
>
> It's more of an issue of having PAE enabled.
> Without PAE you are not able to use the the NX bit.
> That's the way the CPU works, not Linux.

Forgot to add:
from arch/i386/Kconfig:
config X86_PAE
	bool
	depends on HIGHMEM64G
	default y
	select RESOURCES_64BIT

> Hope this helps.
>
