Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbXLCF0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbXLCF0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 00:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXLCFZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 00:25:59 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:8804 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbXLCFZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 00:25:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NwknuhtCXuUu/RhvXTHr722G1fb8HnemrXMG8TvUkM/BMfp9//lqHP5MdXHGFwaGGw05sLPuuA5pIDnEnK64lA/pjeOxqVeclQx5nfUgyV9ecVTo7W2sLo6uHig/Q0XyqZyiQ2MN/HYlRl0FbxO5JJcxdYR6RXFImvMk+nC5yXc=
Message-ID: <aa79d98a0712022125ne3743a4r583dcbdbf2dc2d74@mail.gmail.com>
Date: Mon, 3 Dec 2007 08:25:57 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Thomas Tuttle" <linux-kernel@ttuttle.net>
Subject: Re: Oops with 2.6.24 git when loading iwl3945
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1196617561.16481.1224371239@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1196196237.19410.1223544787@webmail.messagingengine.com>
	 <20071202164316.GB7377@cvg>
	 <1196617561.16481.1224371239@webmail.messagingengine.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/2/07, Thomas Tuttle <linux-kernel@ttuttle.net> wrote:
> On Sun, 2 Dec 2007 19:43:16 +0300, "Cyrill Gorcunov"
> <gorcunov@gmail.com> said:
> > [Thomas Tuttle - Tue, Nov 27, 2007 at 03:43:57PM -0500]
> > | Hey.
> > |
> > | I'm using a git snapshot that gentoo distributed mere hours ago (so I'm
> > | fairly confident it's current), and I'm getting an Oops when I try to
> > | load the iwl3945 driver.  I've attached it as plain text.
> > |
> > | Hope this helps,
> > |
> > | Thomas Tuttle
> >
> > Hi Thomas,
> > Could you please test the patch?
>
> It didn't help.  The original oops says the problem was in strcmp.  It
> was a GPF, which suggests to me that one of the arguments is NULL.
> Since ops->name is checked at the beginning of the function, the only
> other possibility is that alg->ops->name is NULL.  I added a bit of code
> to check for this, and it turns out that one of the strings was indeed
> NULL.  I didn't know where to go from there in debugging, but I hope it
> helps.
>
> Thanks,
>
> Thomas Tuttle
>
Hi Thomas,
could you please attach your kernel's .config (and in bugzilla too).
Thanks.

Cyrill
