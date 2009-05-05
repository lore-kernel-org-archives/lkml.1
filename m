Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbZEET3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbZEET3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 15:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbZEET3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 15:29:00 -0400
Received: from web50112.mail.re2.yahoo.com ([206.190.39.149]:21972 "HELO
	web50112.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751438AbZEET27 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 15:28:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=1w8jH7cVYvEx+wD/3uNrZPCGiEfN0zNnkhuZssprgv7kwGyTl+d/ay81DGx/AfBqQk70LfnCuP2D+9tdZsrPZ1RND6pKbsWT9MjXDcf1sD7bA0eG8bnWP3FfpNLfITbegI7zsDris7Wuxl8Fp6CGlfqQdPIwjIX31Nb7XMMVqDw=;
Message-ID: <651047.14146.qm@web50112.mail.re2.yahoo.com>
X-YMail-OSG: 9sx.mlEVM1lq0BkSsIhKgx2U1vWD_.KTLyb2iyNLjfWX4H05EslXq0OP3lQR9hUq7uZ1QXvH461.ZlhBXFFwEc4vVVDREUnGRRTJHj26q1QwOEs0WhdXa7OHFBcqQAUCZFHutcAeFWyOsQtwFNrskI3SF_XIn_ZsmV.WBxme9icJrDvxNRYpX.BrJ3H3mWkG_g0SY.pFXZ19T86bh_ENaIPc5OQRqMx0m7DhbdEdJdanFu2nYiEo9E5UBp5Jyn2Mw7.jfBXjHISYHXXyxy9ffKm3vg1A6PdVE0ba
X-Mailer: YahooMailClassic/5.3.9 YahooMailWebService/0.7.289.10
Date: Tue, 5 May 2009 12:28:59 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 12/21] amd64_edac: add f10-and-later methods-p2
To: Borislav Petkov <borislav.petkov@amd.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Mon, 5/4/09, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> Subject: Re: [PATCH 12/21] amd64_edac: add f10-and-later methods-p2
> To: "Borislav Petkov" <borislav.petkov@amd.com>
> Cc: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com, linux-kernel@vger.kernel.org
> Date: Monday, May 4, 2009, 5:25 PM
> Borislav Petkov escreveu:
> > +/*
> > + * f10_lookup_addr_in_dct
> > + *
> > + *    Iterate over the DRAM DCT "base"
> and "mask" register looking for
> > + *    a SystemAddr match on the
> specified 'ChannelSelect' and 'NodeID'
> > + *
> > + * Return:
> > + *    -1  NOT FOUND
> > + *    0..csrow = Chip-Select Row
> > + */
> > +static int f10_lookup_addr_in_dct(u32 InputAddr, u32
> NodeID, u32 ChannelSelect)
> > +{
> > +    struct mem_ctl_info *mci;
> > +    struct amd64_pvt *pvt;
> > +    u32 CSBase, CSMask;
> > +    int CSFound = -1;
> > +    int csrow;
> > +
> > +    mci = mci_lookup[NodeID];
> > +    if (!mci)
> > +        return
> CSFound;
> >   
> 
> It is better to use a standard error code like -EINVAL
> instead of using -1 for error.
> 
> 
> Cheers,
> Mauro.
> 

good point thanks

doug t

