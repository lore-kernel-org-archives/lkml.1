Return-Path: <linux-kernel-owner+w=401wt.eu-S933564AbXBXVXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564AbXBXVXn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 16:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933567AbXBXVXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 16:23:43 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:38777 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933564AbXBXVXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 16:23:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PfhLp3OgmC8uvZvRtxRo/7wnWN3VvXkWmbYCQmO6Ajekw4Lq1zsxoonONuthbEr77uStAXPFVEucWoAJ8eO6A6PsnRryZF8+T69GP8qmNZ/EA3T86I7Sv06AMBAzRQcyi3SfhbUmkBLnuIbujxuvE883ndDVi4QbYPHsbGLiO88=
Message-ID: <311601c90702241323i22215a63l33b30e0f0fb009f0@mail.gmail.com>
Date: Sat, 24 Feb 2007 14:23:40 -0700
From: "Eric D. Mudama" <edmudama@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH]: pcmcia - spot slave decode flaws (for testing)
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <20070223120845.19203fcb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070220181836.524e5f9a@localhost.localdomain>
	 <45DEC5A0.7050107@garzik.org>
	 <20070223120845.19203fcb@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/23/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> > Code looks OK. Not applied due to "for testing" note.
> >
> > General comment:  it might be nice to do this in the core, just as a
> > sanity check for a variety of problems, past, present and future.
>
> We tried that with old IDE and all hell broke loose. Lots of virtual disk
> stuff and raid volumes have non-unique serial numbers. We even found a
> case of identically serial numbered Maxtor drives.
>
> It needs to stay in pcmcia, which is the only place we've seen the
> duplication.

I don't think the maxtor drives actually had duplicate serial numbers.
 They were coming back as "M0000000000000000000" or something like
that to the limit of the strlen.  It looked more like buffer
corruption or something, and only happened with one or two people...

--eric
