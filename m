Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYKOKnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYKOKnc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 05:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYKOKnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 05:43:24 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3200 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbYKOKnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 05:43:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] dvb: usb vendor_ids/product_ids are __le16
Date: Sat, 15 Nov 2008 11:42:34 +0100
User-Agent: KMail/1.9.9
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Andy Walls <awalls@radix.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1226686796.5483.33.camel@brick> <1226696157.3312.92.camel@palomino.walls.org> <1226696926.5483.48.camel@brick>
In-Reply-To: <1226696926.5483.48.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811151142.34982.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2008 22:08:45 Harvey Harrison wrote:
> On Fri, 2008-11-14 at 15:55 -0500, Andy Walls wrote:
> > On Fri, 2008-11-14 at 11:44 -0800, Harvey Harrison wrote:
> > > But I'd suggest
> > > that if you want to improve the maintainability of this code that
> > > someone in v4l-land start running sparse regularly
> >
> > For those who don't get the daily 'bot mail on the
> > v4l-dvb-maintainer list, Hans Verkuil's v4l-dvb build 'bot runs
> > sparse builds daily for all of v4l-dvb land:
> >
> > http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-November/00859
> >5.html
> >
> > Although developers won't see waring/error outputs from those runs
> > until after their changes are merged in the main v4l-dvb repo.
> >
> > The latest kernel this automatic sparse build compiles is currently
> > 2.26.28-rc4.  I've used it to monitor the cx18 driver for sparse
> > build errors so I could address them - it's quite convenient.
>
> Does Hans' build turn on __CHECK_ENDIAN__? That would help as well.

Now it does. Thanks for the tip!

	Hans
