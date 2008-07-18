Return-Path: <linux-kernel-owner+w=401wt.eu-S1759841AbYGRCZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841AbYGRCZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 22:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYGRCZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 22:25:25 -0400
Received: from c-68-35-23-177.hsd1.nm.comcast.net ([68.35.23.177]:51087 "EHLO
	deneb.dwf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbYGRCZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 22:25:24 -0400
Message-Id: <200807180219.m6I2J0jN002994@deneb.dwf.com>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
To: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
cc: linux-kernel@vger.kernel.org, reg@fw.dwf.com
Subject: Re: Does 2.6.26 provide nanosecond time to the user? 
In-reply-to: <yw1x1w1srmqq.fsf@thrashbarg.mansr.com> 
References: <200807180019.m6I0J2kG026240@deneb.dwf.com> 
 <yw1x1w1srmqq.fsf@thrashbarg.mansr.com>
Comments: In-reply-to =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
   message dated "Fri, 18 Jul 2008 02:42:53 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Date: Thu, 17 Jul 2008 20:19:00 -0600
From: Reg Clemens <reg@dwf.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Reg Clemens <reg@dwf.com> writes:
> 
> > Im confused.
> > (sorry I havent been following the linux-kernel mailing list on this)
> >
> > Does 2.6.26 use nanosecond time
> >     (1) internally?
> >     (2) provide it to the user?
> >
> > I see no way to turn it on/off in xconfig.
> > Yet I do see STA_NANO defined in sys/timex.h which is a good start.
> >
> > and IF it provides it to the user, what do I use to get nanosecond time.
> > My search with man -k for timespec turns up
> >       sys_clock_getres
> > and sys_clock_gettime
> >
> > or possibly clock_getres and clock_gettime, the man pages use both,
> > but NONE of these entry points seem to exist in my system.
> 
> You might need to link with -lrt to get those functions.
> 
Thanks, -lrt works fine, that answers that part of the question, how about
the first question.

-- 
                                        Reg.Clemens
                                        reg@dwf.com


