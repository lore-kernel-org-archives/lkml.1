Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbYETB03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbYETB03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 21:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYETB0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 21:26:21 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:47240 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752507AbYETB0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 21:26:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=S45KoJJvwOcnUlD81c0q1b34NmmpOd8+JrSq6lH7Us092ZWuLcW/pSxs7BJUih53mve9hPuDH7ePvphxHLrvNmPAiAt2rI+CAc9NfezpzUKp6dixoX3Zfz3p2LcfAGZP/fGeEfcj0ulz1H4OTRYVz1NgXzRKUz+mIZEGU46g8X0=  ;
X-YMail-OSG: WsasHTwVM1kYWuxGy6iElFn3zfaMxRz1R_HTtAXR16mqLqjOmlGqX_uxKiVQelyeBwug1iOiFmwhf4xn2OLoDc.STlEITk7QviBzIV2lntQK6r4JjjhqeN5ESe8EfhPng3Q-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Date: Mon, 19 May 2008 18:26:18 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Ben Nizette <bn@niasdigital.com>, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
References: <200804281239.51729.david-b@pacbell.net> <200805171514.07619.david-b@pacbell.net> <20080519223933.GA2315@elf.ucw.cz>
In-Reply-To: <20080519223933.GA2315@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805191826.18516.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2008, Pavel Machek wrote:
> 
> > 
> > > What about mkdir gpio-N to export it?
> > 
> > Ugh.  That would create way more complication than I want
> > to see here.  I thought about that early on, and decided
> > that was Not The Way To Go.
> 
> ...but it would be consistent with configfs... and face it... doing
> echo > file to make a directory is seriously ugly.

This isn't configfs, and I didn't happen to notice any polite
way for sysfs users to intercept "mkdir", parse the relevant
directory name, reject illegal names, and pre-populate the
just-created directory with relevant contents.


Were you implying it should go into configfs?  If so, do you
maybe have an update to the patch I sent a day or so ago?

