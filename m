Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbYJHEY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbYJHEY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 00:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbYJHEYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 00:24:50 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:32617 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750826AbYJHEYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 00:24:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VOR08dbQXVqyBPL19ceJO8jLBmbVOD7cpABAmTiSA519FktrMzDPRABWiHs/9pcdC3Abl8r0BTAWVccAczTCZNOMxzQbGnJxn/wCas66mXMv/t4WMlavahY3GByj4lRiolOwgx3eBGRnCpac8zs1lQffcTa5rhfJbeOU97NtISA=  ;
X-YMail-OSG: gbWf_ZwVM1kHNx2k1CIQ5f.E4AMxQOEdCIJ8nO7V5H6lKNdA.NL8wlks4zTJfwNYTZoidexpaeKHFUBfnwu3AY6x_ni0XhScxiM2us89wJEYoSm2oFpytJUTuv7nBKzTq6De5.X.Cg9zcAGfz4W6Lrt97.TO_DrscLozUvkv.6YRmoKjEA7EiiJyojcs
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Dave Jones <davej@redhat.com>
Subject: Re: [Bug #11224] Only three cores found on quad-core machine.
Date: Wed, 8 Oct 2008 15:24:40 +1100
User-Agent: KMail/1.9.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <0pOgGB.A.uLG.E475IB@wind> <200810080218.18898.nickpiggin@yahoo.com.au> <20081007153203.GB3337@redhat.com>
In-Reply-To: <20081007153203.GB3337@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810081524.40614.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008 02:32, Dave Jones wrote:
> On Wed, Oct 08, 2008 at 02:18:18AM +1100, Nick Piggin wrote:
>  > On Sunday 05 October 2008 04:32, Rafael J. Wysocki wrote:
>  > > This message has been generated automatically as a part of a report
>  > > of recent regressions.
>  > >
>  > > The following bug entry is on the current list of known regressions
>  > > from 2.6.26.  Please verify if it still should be listed and let me
>  > > know (either way).
>  > >
>  > >
>  > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11224
>  > > Subject		: Only three cores found on quad-core machine.
>  > > Submitter	: Dave Jones <davej@redhat.com>
>  > > Date		: 2008-08-01 18:15 (65 days old)
>  > > References	: http://marc.info/?l=linux-kernel&m=121761475224719&w=4
>  >
>  > Dave, is your CPU2 getting stuck in calibrate_delay? Can you still
>  > reproduce the bug? What if you boot the kernel with lpj=<something sane
>  > like 2666785> in order to skip the calibrate_delay code?
>  >
>  > If that helps, can you try adding some printks to narrow down where it
>  > is getting stuck?
>
> This is going to sound strange, but I've forgotten which box that was.
> I'm due to reinstall all my test boxes now that the next Fedora beta
> has come out anyway, so I'll hopefully figure out by the end of the week :)

That does sound strange ;) But I can't believe that! It would be really
interesting if it was stuck in calibrate_delay, but maybe the backtrace
is just messed up...

If you do manage to reproduce it, I would be quite interested. Otherwise,
I think we can say it's not a showstopper for 2.6.27.
