Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbXFYWok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbXFYWok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbXFYWob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:44:31 -0400
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:34239 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277AbXFYWob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:44:31 -0400
Date: Tue, 26 Jun 2007 00:42:22 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: harald@skogtun.org
Cc: schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, david@lang.hm
Subject: Re: Linux Kernel include files
Message-ID: <468044ce.TbSfwc4mY5Plx+iX%Joerg.Schilling@fokus.fraunhofer.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
 <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
 <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
 <1182483527.10524.31.camel@shinybook.infradead.org>
 <467fdc75.0ficjl92unPDO1uk%Joerg.Schilling@fokus.fraunhofer.de>
 <1182785277.12109.121.camel@pmac.infradead.org>
 <87wsxrdi6e.fsf@basilikum.skogtun.org>
 <468024ec.9RebHj/O0BpNRyoY%Joerg.Schilling@fokus.fraunhofer.de>
 <87ir9byak9.fsf@basilikum.skogtun.org>
 <87ejjzyac0.fsf@basilikum.skogtun.org>
 <4680384e.iAYvC5ix5Dbya44W%Joerg.Schilling@fokus.fraunhofer.de>
 <87hcovy8dz.fsf@basilikum.skogtun.org>
In-Reply-To: <87hcovy8dz.fsf@basilikum.skogtun.org>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Arnesen <harald@skogtun.org> wrote:

> Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling) writes:
>
> >> FYI, cdrtools also compile and link fine with Sun's C compiler.
> >
> > Mmmmm, if you call "cdrecord -scanbus", what do you get?
>
> I may have misunderstood your make system. I cd-ed into the cdrtools
> directory, ran ./Gmake.linux clean (I had already compiled with GCC),
> and then ./Gmake.linux CCOM=suncc. I didn't see any errors at the end of
> the make output.
>
> However, what confused me was that the cdrecord binary wasn't removed.
> And scrolling back, I see several compile errors from Sun's C compiler.
>
> Shouldn't "make clean" remove the executable files?

make clean only removes the *.o files.

If you call "make relink", all results are removed before recreating.

BTW: your problem is caused by a "bash" bug. With a shell that correctly
works with "sh -ce 'command...'", you would see an abort after the first
error.

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
