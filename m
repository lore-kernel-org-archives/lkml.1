Return-Path: <linux-kernel-owner+w=401wt.eu-S1161356AbXDQS0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161356AbXDQS0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 14:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161362AbXDQS0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 14:26:43 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:41594 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161356AbXDQS0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 14:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=o4H9QxGc1G+B+wTf9GPr9Y+/974U1UsgvLeunPx4bo7tbkp/xCFWVE6BR+URBJ8z9IYSTfdKRuCYzZm1wn2Tn6Q9L15aElT5AOAYkgrtOmgfpOiQtmu4Xlc8KuhAivTUeiFmOU2/pa3P37zwhamwgo1qq2YAuB+RjiT8Be+DVCg=
Message-ID: <837c0d330704171126n551010d7v6759fc9a516878ab@mail.gmail.com>
Date: Tue, 17 Apr 2007 20:26:40 +0200
From: "Jasper Spaans" <jasper@vs19.net>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: 4GB Physical. Less than 3GB in Linux.
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <b6a2187b0704160752u1c837f33p652c0d431b66459@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.wZS4ieAkOMvNOj61QiUn9aS+YeM@ifi.uio.no>
	 <46238936.3060501@shaw.ca>
	 <b6a2187b0704160752u1c837f33p652c0d431b66459@mail.gmail.com>
X-Google-Sender-Auth: dd713f826abe0849
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/07, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On 4/16/07, Robert Hancock <hancockr@shaw.ca> wrote:
> > Jeff Chua wrote:
> > > I've noticed that with 4GB physical ram, I'm only see 3098000 MB on
> > > the Dell 745, and 3107056MB on the IBM X60s.
> > >
> > > I've tested with CONFIG_HIGHMEM4G=y, CONFIG_HIGHMEM64G=y,
> > > CONFIG_X86_PAE=y, but nothing makes any difference.
> >
> > Chipset limitation. It uses up most of the MMIO region above 3GB
> > preventing RAM from being mapped there, and doesn't support remapping
> > the covered RAM to above 4GB. Nothing the kernel can do about it.
>
> Well, I guess I learned the hard way. So it's better not to buy 4GB
> ... it turns out to be the same as buying one with just 3GB RAM.

Might be a setting in the bios... look for something like memory hole,
memory remapping, 4G DRAM, etc.

VrGr,
-- 
Jasper Spaans                                       http://jsp.vs19.net/

               This line was last modified 0 seconds ago.
