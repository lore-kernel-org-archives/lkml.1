Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbXFZAIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbXFZAIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 20:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbXFZAIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 20:08:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:54588 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbXFZAIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 20:08:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bZcIUofzoVlKmCbcg7zO0bkrobjMM6IphoIvs7L5/yJ0XZi5DqdlAfMreF8czVEH+N0JNHb/MZjDloOrvMCTeIRMKkYF0WYxc67YCHGwwy52egDZJd2Ld5SvJhRdBBsalB28yG/w3r6ZJrumWHISMs/mFU8nw67Mzeq2YHd4y+g=
Message-ID: <6934efce0706251708h7ab8d7dal6682def601a82073@mail.gmail.com>
Date: Mon, 25 Jun 2007 17:08:02 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: vm/fs meetup in september?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070624042345.GB20033@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070624042345.GB20033@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> A few things I'd like to talk about are:
>
> - the address space operations APIs, and their page based nature. I think
>   it would be nice to generally move toward offset,length based ones as
>   much as possible because it should give more efficiency and flexibility
>   in the filesystem.
>
> - write_begin API if it is still an issue by that date. Hope not :)
>
> - truncate races
>
> - fsblock if it hasn't been shot down by then
>
> - how to make complex API changes without having to fix most things
>   yourself.

I'd like to add:

-revamping filemap_xip.c

-memory mappable swap file (I'm not sure if this one is appropriate
for the proposed meeting)
