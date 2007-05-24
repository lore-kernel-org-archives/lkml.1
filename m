Return-Path: <linux-kernel-owner+w=401wt.eu-S1763169AbXEXDkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763169AbXEXDkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 23:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760555AbXEXDkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 23:40:23 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:10241 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760321AbXEXDkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 23:40:23 -0400
X-IronPort-AV: i="4.14,571,1170651600"; 
   d="scan'208"; a="30798478:sNHT28935102"
Subject: Re: [PATCH] blackfin: Enable arbitary speed serial setting
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Aubrey Li <aubreylee@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, aubrey.li@analog.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <6d6a94c50705232023w18fea193i44f1409dc7dd3377@mail.gmail.com>
References: <20070523173050.275119c7@the-village.bc.nu>
	 <6d6a94c50705232023w18fea193i44f1409dc7dd3377@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 24 May 2007 11:39:10 +0800
Message-Id: <1179977950.23609.4.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 11:23 +0800, Aubrey Li wrote:
> Thanks.
> 
> Acked-by: Aubrey Li <aubrey.li@analog.com>
> 
> On 5/24/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Add the needed definitions to activate arbitary speed support on the
> > blackfin platform.
> >
> > Signed-off-by: Alan Cox <alan@redhat.com>
> >

I noticed another patch from Alan "lots-of-architectures: enable
arbitary speed tty support" is added to -mm tree, which defined struct
termios2. That is required by this one.

So it should be tested together and merged together, although Aubrey
didn't received the
lots-of-architectures-enable-arbitary-speed-tty-support.patch from LKML.

Thanks a lot
-Bryan Wu
