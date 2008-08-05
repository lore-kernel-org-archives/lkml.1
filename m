Return-Path: <linux-kernel-owner+w=401wt.eu-S1762121AbYHEPw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762121AbYHEPw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761605AbYHEPwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:52:16 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:40739 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761547AbYHEPwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:52:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=yUCqBXvMzagyR59EwjoK1uSAN5UN4nSay9I4IXMU2SGMOg9c2/JnNuUbKj1zplkWjCCW6cdG+7iGN34HY6z+FJ/YFYubhdS6ShfedxhEf4KuMTmNWSP0aqg2SndzKOALEHXSIsQR3FRYJeQudtL4+IS4Zu1/6r2oBSsZ0iy0V0M=  ;
X-YMail-OSG: oUEN0oMVM1mJboJlxOG2AxihTu2w8yHmPESkvADCAq.CcICMOANdu9HOjMBOlIC1.mKIpxJz7PCgLjO6cmzyYYdDVqotmrRa0qZlNjchyQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: jmerkey@wolfmountaingroup.com
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Date: Wed, 6 Aug 2008 01:45:22 +1000
User-Agent: KMail/1.9.5
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Josh Boyer" <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <200808060133.10457.nickpiggin@yahoo.com.au> <44919.166.70.238.45.1217949560.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <44919.166.70.238.45.1217949560.squirrel@webmail.wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808060145.22321.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008 01:19, jmerkey@wolfmountaingroup.com wrote:
> > On Wednesday 06 August 2008 01:02, jmerkey@wolfmountaingroup.com wrote:
> >> > On Mon, 4 Aug 2008, jmerkey@wolfmountaingroup.com wrote:
> >> >
> >> > --
> >> > Geert Uytterhoeven -- There's lots of Linux beyond ia32 --
> >> > geert@linux-m68k.org
> >>
> >> No I was not, but I am now.  At any rate, I removed the Microsoft-isms
> >> from the code.  I can cut yet another patch for git6, but git5 was there
> >> -- GPL2 and all.  How about putting in into the kernel guys -- :-)
> >
> > Seriously? Because it doesn't seem to have had enough peer review,
> > it hasn't had widespread testing in somewhere like linux-next or
> > -mm, and we already have kgdb so you have to also explain why you
> > can't improve kgdb in the areas it trails mdb.
>
> If you go back to LKML from 2000, this debugger has been around for 10
> years.  I agree not in the hands of the public, but its very mature
> in comparison to kdb or kgdb.

OK I don't doubt that at all, but I just mean in terms of being reviewed
by Linux people and how it merges with the current kernel (eg. we now
have a debugger, which was unthinkable in 2000 :)).


> > But the ideal outcome would be if you could contribute patches to
> > kgdb to the point where it is as good as mdb. It is already in the
> > tree and supported by a handful of architectures... any chance of
> > that? (I don't know kernel debugger code, so I ask as an interested
> > user)
>
> I plan to work on kdb and yes, there is a version of this that runs
> as an alternate debugger of kdb - you can even switch back and forth
> between them - but that misses the point as well.
>
> I can wait untl its more widespread -- or not.

That would be great if you do work on kgdb... But I guess I do miss
the point, then. Is there a technical difference with kgdb that cannot
be worked around, a difference of opinion with maintainers, a wish to
have mdb features at short notice?
