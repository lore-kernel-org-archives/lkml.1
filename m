Return-Path: <linux-kernel-owner+w=401wt.eu-S1759766AbXH3QLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766AbXH3QLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 12:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757168AbXH3QK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 12:10:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:43798 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821AbXH3QK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 12:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CGl8HaRKzIWOTWb0qhIlfqvuSfK89/iC+AZWpEZrVs5InaMaQNHOMPDpKsMp7fhy3Nc/22JgArEkugAJV7+LSXrcZsFM3tQaoHhEK4aHz81vd+nNSoRg9P7F+CwCvIwK7DVGu6ePbAXphChg4UL93AokaHXD0T4V20wAajQyRkY=
Message-ID: <ab40e9c0708300910m3cba4c7bie3f6c9d471a155ff@mail.gmail.com>
Date: Thu, 30 Aug 2007 18:10:55 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: "Uli Luckas" <u.luckas@road.de>
Subject: Re: parse_tag_ramdisk
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200708301806.42905.u.luckas@road.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab40e9c0708300707r2e6d2d71y42940084db5038ac@mail.gmail.com>
	 <200708301806.42905.u.luckas@road.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uli,


thanks for your reply.

just have a question, where is the tag list, how can i modify this?

regards,
yang

2007/8/30, Uli Luckas <u.luckas@road.de>:
> On Thursday, 30. August 2007, Xu Yang wrote:
> > Hi guys,
> >
> >
> > I found that in the function parse_tag_ramdisk , the setup_ramdisk is
> > called. is it true that in the setup_ramdisk the location ot the
> > initrd is specified?
> >
> > it seems that in my case the parse_tag_ramdisk is never accessed. what
> > might cause this?
> >
> Hi Xu,
> I didn't get down to completely debugging this problem. But for no obvious
> reason, parsing seems to ends after it hits a command line tag.
> Try putting the command line tag last in the tag list and see if that helps.
>
> Regards
> Uli
>
> --
>
> ------- ROAD ...the handyPC Company - - -  ) ) )
>
> Uli Luckas
> Software Development
>
> ROAD GmbH
> Bennigsenstr. 14 | 12159 Berlin | Germany
> fon: +49 (30) 230069 - 64 | fax: +49 (30) 230069 - 69
> url: www.road.de
>
> Amtsgericht Charlottenburg: HRB 96688 B
> Managing directors: Hans-Peter Constien, Hubertus von Streit
>
