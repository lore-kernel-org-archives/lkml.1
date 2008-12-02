Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYLBR0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYLBR0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 12:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbYLBR0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 12:26:39 -0500
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1149 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbYLBR0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 12:26:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng
Date: Tue, 2 Dec 2008 18:26:08 +0100
User-Agent: KMail/1.9.9
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>, video4linux-list@redhat.com,
       "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       davinci-linux-open-source-bounces@linux.davincidsp.com
References: <200812011246.08885.hverkuil@xs4all.nl> <200812021758.35503.laurent.pinchart@skynet.be> <20081202152100.0a4dd2c1@pedra.chehab.org>
In-Reply-To: <20081202152100.0a4dd2c1@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812021826.09133.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 December 2008 18:21:00 Mauro Carvalho Chehab wrote:
> On Tue, 2 Dec 2008 17:58:35 +0100
>
> Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> > > Are you meaning marking this as experimental at Kconfig? This
> > > seems too complex, since we'll need to test for some var on every
> > > driver that were converted, providing two KABI options for each
> > > converted driver (the legacy and the v4l2_device way). This
> > > doesn't seem to be a good idea, since will add a lot of extra
> > > complexity to debug bugs.
> >
> > Not at the Kconfig level, just in the documentation (and possible
> > headers).
>
> Ah, ok. Good point.
>
> > This is a work in progress. Hans wants the changes to go mainline
> > to get broader testing, which is a valid reason, but I'd like to
> > make sure people understand that more changes are coming.
>
> Maybe instead we should have a TODO list somewhere with the
> programmed changes, especially at the subsystem core.

Sure, I can add some comments outlining future developments in 
v4l2-device.h and v4l2-subdev.h. The v4l2-framework document can point 
to those headers (headers are easier to keep in sync when new features 
arrive than documentation).

But I'll wait with this until I get Mauro's review back, just in case 
there are more changes for me to do.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
