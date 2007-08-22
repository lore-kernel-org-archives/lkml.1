Return-Path: <linux-kernel-owner+w=401wt.eu-S1764814AbXHVQS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764814AbXHVQS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763208AbXHVQST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:18:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34221 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763264AbXHVQST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:18:19 -0400
Date: Wed, 22 Aug 2007 09:17:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>,
       Greg KH <greg@kroah.com>
Subject: Re: 2.6.23-rc3-mm1
Message-Id: <20070822091755.59d3af01.akpm@linux-foundation.org>
In-Reply-To: <6bffcb0e0708220719j7b07adabl74959c36256df2e@mail.gmail.com>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<6bffcb0e0708220719j7b07adabl74959c36256df2e@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 16:19:33 +0200 "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:

> On 22/08/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> >
> 
> allyesconfig
> 
>   RELOCS  arch/i386/boot/compressed/vmlinux.relocs
> WARNING: Absolute relocations present
> Offset     Info     Type     Sym.Value Sym.Name
> c06018f3 02ee1f01   R_386_32 c14adad0  _sdata
> 

Yeah, that's Greg's pestiferous
gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch acting
up.

I previously suggested that something like kallsyms_lookup() could be used
for this, but I was cruelly ignored.

