Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbXFNBR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbXFNBR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 21:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbXFNBRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 21:17:51 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:29294 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337AbXFNBRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 21:17:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZancZmelqqbnZ82uipEqlDcELUt+IrwnX0idOx8CODwMcqyYNxQJ0rOy/T24PBWHy/h2xAVi8jy/MmWv28XtW5VZi9nzCKn6ZAEQBLdrYigoCLDmssZtpGTvsZim/Df8jIK838Fuy+ipF9IPE/LyIRcQ6mGJmTMwDH0sybjy4bg=
Message-ID: <21d7e9970706131817t40ca2d77w658e2540dc3ee7c4@mail.gmail.com>
Date: Thu, 14 Jun 2007 11:17:50 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Carlo Wood" <carlo@alinoe.com>, "Dave Jones" <davej@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: DRI/AGP on AMD64 based machine
In-Reply-To: <20070614011506.GA30566@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181721735.4418.10.camel@malory>
	 <20070613162925.GG3875@redhat.com> <20070614011506.GA30566@alinoe.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/07, Carlo Wood <carlo@alinoe.com> wrote:
> On Wed, Jun 13, 2007 at 12:29:25PM -0400, Dave Jones wrote:
> > For the sake of AGP, we only use the on-CPU GART.
> > The (nvidia) chipset one is ignored.
> >
> > If amd64-agp isn't working for you, attach your dmesg.
> > (You can also confirm its working by running testgart[1])
>
> Hi Dave, I have an amd64 box for which every kernel
> after 2.6.18 hangs during boot, so I have no dmesg :(
>
> I used git bisect to find out where the problem patch is,
> and assuming bisect works (imho it jumped between versions
> very weirdly: closing in on the last 6 revisions, it
> jumped from 2.6.18 to 2.6.18-rc2 to 2.6.18-rc6), the problem
> is a patch in intel-agp.c, where support for the intel 965G
> is added (which I have).

How do you have a 965G in an amd64 box? does not compute.

Dave.
