Return-Path: <linux-kernel-owner+w=401wt.eu-S933622AbXIBGan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622AbXIBGan (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 02:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXIBGaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 02:30:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:45484 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbXIBGae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 02:30:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dvakfaSdQChoZPmkChiRAHDTxJK4N1DrsE83aL55syT85t24ROBuUVNT4kvUg8sHFYH/icD5EQUslNsda2Y1rS7pP3nHuKC9+qqpjjSKM/UntaY1b1LE5eDau96rMyt5B+mX2sDR0ncs//HCfQqI0zMPfxAi2GKyNP0Sl2iXB9c=
Message-ID: <91b13c310709012330n5ab23496p86423bdcd4fd08f2@mail.gmail.com>
Date: Sun, 2 Sep 2007 14:30:32 +0800
From: "rae l" <crquan@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] net/ipv4/af_inet.c: use ARRAY_SIZE macro from kernel.h instead
Cc: "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0709020100180.17742@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11887091471748-git-send-email-crquan@gmail.com>
	 <Pine.LNX.4.64.0709020100180.17742@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/2/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Sun, 2 Sep 2007, Denis Cheng wrote:
>
> > Signed-off-by: Denis Cheng <crquan@gmail.com>
> > ---
> >  net/ipv4/af_inet.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > index e681034..d5e8b67 100644
> > --- a/net/ipv4/af_inet.c
> > +++ b/net/ipv4/af_inet.c
> > @@ -939,7 +939,7 @@ static struct inet_protosw inetsw_array[] =
> >         }
> >  };
> >
> > -#define INETSW_ARRAY_LEN (sizeof(inetsw_array) / sizeof(struct inet_protosw))
> > +#define INETSW_ARRAY_LEN ARRAY_SIZE(inetsw_array)
> >
> >  void inet_register_protosw(struct inet_protosw *p)
> >  {
>
> denis:
>
> if you're planning on doing this ARRAY_SIZE cleanup fairly rigorously,
> here's an overview of what you're looking (based on a fairly dumb
> scanning script that undoubtedly generates some false positives).  of
> course, the respective subsystem maintainers are welcome to deal with
> them first, of course.
>
> p.s.  and when you submit those patches, it's necessary to submit them
> to only the appropriate subsystem mailing lists, not to the LKML in
> general.
I didn't realize that there's so many places to switch to ARRAY_SIZE,
so now I wonder is this cleaning work valuable to the whole kernel tree?
or we can keep the current state and just encourage new code to use ARRAY_SIZE?

--
Denis
