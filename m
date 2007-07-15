Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbXGOEuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbXGOEuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 00:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXGOEt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 00:49:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:16074 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbXGOEtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 00:49:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LtSIUtY2kvKLfCFn/u+2qt4aJmTD6gSWhOOvAcrySwJg46si46qutjk7yBGxdw8ZxqgCbL0+11/QrVkiI6sBvI0MsxnjyJcamKXVraQnDYIR0WEqr2YEGQLAblrsXGmDBTogCNad87a+kmEHrI+Led98SiR7ClkTMzsh1uQyITA=
Message-ID: <787b0d920707142149p3899ddbcy75358392e8ab4563@mail.gmail.com>
Date: Sun, 15 Jul 2007 00:49:54 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH] remove PAGE_SIZE from headers_install
Cc: olaf@aepfle.de, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070714.204314.70218766.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920707141948t71b4059s7ae68610f9f81eac@mail.gmail.com>
	 <20070714.204314.70218766.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/14/07, David Miller <davem@davemloft.net> wrote:
> From: "Albert Cahalan" <acahalan@gmail.com>
> Date: Sat, 14 Jul 2007 22:48:57 -0400
>
> > A real constant-value PAGE_SIZE is useful and doable.
>
> It's bogus to use it.  The kernel can get recompiled
> to arbitrary page sizes on some architectures, so a constat
> page size assumption cannot work.

Sure it can work. The ABI specifies limits on such things.
Probably the most appropriate size is the one specified
for alignment of ELF sections.

If I remember right, it's 64 K for the PowerPC ABI. This allows
for 64 K pages, even though many chips offer 4 K pages.
