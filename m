Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbXEMTU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbXEMTU3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757333AbXEMTUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:20:23 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:27447 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594AbXEMTUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:20:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X2jTtB1jYx5jxI2PaiB251LDTmsBQQ4t2mDS5N8XoVxrVTXflc2rg1okXaAOLzBbzX9iXw5w3Amlhvc8Xz0Q1njWvgTN0I1a8ka0SCoxzOgNL96Tg7HP41yLrqg9kes1Zs19W/HFtO3u7xfJEhidPUSic1Mm55+fRKPLNhD7mFk=
Message-ID: <f56c1ba00705131220i3ec8a21es789a5c25893a9c78@mail.gmail.com>
Date: Sun, 13 May 2007 21:20:21 +0200
From: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: + timer_stats-slimmed-down-using-statistics-infrastucture.patch added to -mm tree
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mp3@de.ibm.com,
       mingo@elte.hu, tglx@linutronix.de
In-Reply-To: <1179082720.19106.4.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200704210018.l3L0IJBN027188@shell0.pdx.osdl.net>
	 <1179082720.19106.4.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/13, Arjan van de Ven <arjan@infradead.org>:
> On Fri, 2007-04-20 at 17:18 -0700, akpm@linux-foundation.org wrote:
> > The patch titled
> >      timer_stats slimmed down: using statistics infrastucture
> > has been added to the -mm tree.  Its filename is
> >      timer_stats-slimmed-down-using-statistics-infrastucture.patch
> >
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> >
> > See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> > out what to do about this
> >
> > ------------------------------------------------------
> > Subject: timer_stats slimmed down: using statistics infrastucture
> > From: Martin Peschke <mp3@de.ibm.com>
> >
> > This patch implements timer_stats based on the statistics infrastructure.
> >
> > Here is some sample output, which even somewhat
> > resembles /proc/timer_stats.
> > (>80 char lines because of symbol names, sorry for line breaks).
> >
> > It reads:
> > <statistic name> <basket> <hits> <label>
> >
> > with label being:
> > <pid> <task name> <start_fn>(<stop_fn>)
> >
> > [root@t2930041 timer_stats]# cat data
>
> this patch changes the userspace API though, and breaks PowerTOP :(
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Moreover, the documentation still refers to /proc/timer_stats which do
not appear in my 2.6.21-mm2 kernel.

Regards,
Cédric
