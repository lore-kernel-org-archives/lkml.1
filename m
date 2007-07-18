Return-Path: <linux-kernel-owner+w=401wt.eu-S1763277AbXGRDQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763277AbXGRDQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 23:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbXGRDQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 23:16:26 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:32423 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbXGRDQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 23:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M4hThtxDL5gi5eTDV4eFtw7wogkt0DivsTqW4E0IM6dMDZG3u+M7ewUhazx30EcUzj2h/XV3KQec7hY6l0//+Uihy8gBu9p8bJYG8WzG6d7hqQ3czFpeHPxZT7Ihb5YsF/iVz4h86GwWef8NpwLjjMJ3AnPxLFLSf/o8yR8gdzI=
Message-ID: <8734b7880707172016v530ce775p108910f7baf9de8e@mail.gmail.com>
Date: Wed, 18 Jul 2007 13:16:24 +1000
From: "Lindsay Roberts" <lindsay.roberts.os@gmail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [PATCH] fs: Add romfs version 2
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, celinux-dev@tree.celinuxforum.org
In-Reply-To: <20070717192100.GE11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8734b7880707122301m400294d4nf12072f949c95fa4@mail.gmail.com>
	 <20070717013635.d6d0b124.akpm@linux-foundation.org>
	 <20070717192100.GE11166@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/07, Matt Mackall <mpm@selenic.com> wrote:
> > > * Adds new derivative of romfs filesystem (rom2fs) with
> > >   block aligned regular file data to bring performance
> > >   parity with ext2/3. This is about 225% of the read
> > >   speed of the existing romfs.
>
> Doesn't that make these filesystems much bigger? By, on average, .5k
> per file? Or, if I'm understanding things correctly, ~1k?

Yes, my experience has been that it has been almost chillingly close
to .5k per regular file increase in partition size. I know in
applications in which size is utterly critical this may be slightly
unattractive, but in cases where romfs is chosen for its byte
reproducibility and read-only nature the size/performance tradeoff is
fairly advantageous.
