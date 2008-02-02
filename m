Return-Path: <linux-kernel-owner+w=401wt.eu-S1763093AbYBBAy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763093AbYBBAy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759306AbYBBAyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:54:18 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:25298 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756849AbYBBAyS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:54:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UT+9qy4Y5jnB1da6pWj1I4LwrClYTtfsm/nzJJ6TPYss4BSjAzfUXhV5SlaGBk8/gGu6bjtzLzJ71HfYwxco1bGRSPkMWlmM8otFyG0hkad2NHrcG3A6rJhoAOK92haJBB6mtxNRyAK853/FSrRGN6GVf/W2JiEQEgsuvj816m4=  ;
X-YMail-OSG: udQ.hj0VM1mudlkyi60nJ6j2zauY0HwcdAMdVPH4AYjv8mQp7ECkDiYIWwtdd7N7bkQZrNZr0g--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: 2.6.24 regression: pan hanging unkilleable and un-straceable
Date: Sat, 2 Feb 2008 11:53:56 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
References: <1200949086.6648.19.camel@Anastacia> <200801281246.24043.nickpiggin@yahoo.com.au> <1201819559.2965.2.camel@Anastacia>
In-Reply-To: <1201819559.2965.2.camel@Anastacia>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802021153.56519.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2008 09:45, Frederik Himpe wrote:
> On ma, 2008-01-28 at 12:46 +1100, Nick Piggin wrote:
> > On Sunday 27 January 2008 00:29, Frederik Himpe wrote:
> > > On di, 2008-01-22 at 16:25 +1100, Nick Piggin wrote:
> > > > > > On Tuesday 22 January 2008 07:58, Frederik Himpe wrote:
> > > > > > > With Linux 2.6.24-rc8 I often have the problem that the pan
> > > > > > > usenet reader starts using 100% of CPU time after some time.
> > > > > > > When this happens, kill -9 does not work, and strace just hangs
> > > > > > > when trying to attach to the process. The same with gdb. ﻿ps
> > > > > > > shows the process as being in the R state.
> >
> > Well after trying a lot of writev combinations, I've reproduced a hang
> > *hangs head*.
> >
> > Does this help?
>
> Just to confirm: in four days of testing, I haven't seen the problem
> anymore, so it looks like this was indeed the right fix.

Thanks very much for reporting and testing. This patch needs to go
into 2.6.24.stable and upstream.
