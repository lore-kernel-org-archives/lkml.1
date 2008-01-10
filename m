Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbYAJXJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbYAJXJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYAJXJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:09:41 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:21909 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbYAJXJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:09:40 -0500
Subject: Re: [x86] list of style offenders
From: Daniel Walker <dwalker@mvista.com>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4d8e3fd30801101435l228a0d0ydd0174e4073400e6@mail.gmail.com>
References: <1199995391.29897.26.camel@imap.mvista.com>
	 <4d8e3fd30801101435l228a0d0ydd0174e4073400e6@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 15:08:01 -0800
Message-Id: <1200006481.29897.48.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 23:35 +0100, Paolo Ciarrocchi wrote:
> On Jan 10, 2008 9:03 PM, Daniel Walker <dwalker@mvista.com> wrote:
> >
> >
> > I was playing with checkpatch.pl ;) .. I made a list of style offenders
> > inside the arch/x86/ sub-directory. I thought it might be helpful to
> > prioritize any style clean ups that people might want to do for x86 ..
> > OTOH some of these might show imperfections in checkpatch.pl .. Either
> > way I thought it was interesting to review ..
> >
> > These are sorted by errors, then warnings.. I only included the first
> > hundred files which includes about the top %30 of the list .. The
> > kprobes_64.c error rate is a little miss-leading because several errors
> > are found on a single line ..
> 
> I just pulled
> git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86 mm
> 
> > ./arch/x86/math-emu/fpu_trig.c
> >                 total: 649 errors, 11 warnings, 1845 lines checked
> 
> On that tree checkpatch reports:
> total: 5 errors, 54 warnings, 1643 lines checked
> 
> > ./arch/x86/kernel/kprobes_64.c
> >                 total: 528 errors, 9 warnings, 749 lines checked
> 
> total: 0 errors, 0 warnings, 1 lines checked

I pulled the tree your working with , and it's got mostly the same
issues .. Are you sure your running the commands properly?

The "lines checked" values that you listed looks wrong .. A few you
listed as "0 lines checked" , or "1 lines checked" .. Which can't be
right..

The git logs also show that arch/x86/math-emu/fpu_trig.c hasn't been
modified since it was pull in on Oct. 11 ..

Daniel



