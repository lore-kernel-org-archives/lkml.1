Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbYLBRV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbYLBRV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 12:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbYLBRVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 12:21:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59395 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbYLBRVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 12:21:19 -0500
Date: Tue, 2 Dec 2008 15:21:00 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, video4linux-list@redhat.com,
       "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       davinci-linux-open-source-bounces@linux.davincidsp.com
Subject: Re: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-ng
Message-ID: <20081202152100.0a4dd2c1@pedra.chehab.org>
In-Reply-To: <200812021758.35503.laurent.pinchart@skynet.be>
References: <200812011246.08885.hverkuil@xs4all.nl>
	<200812011524.43499.laurent.pinchart@skynet.be>
	<20081201130643.661f5743@pedra.chehab.org>
	<200812021758.35503.laurent.pinchart@skynet.be>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2008 17:58:35 +0100
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> > Are you meaning marking this as experimental at Kconfig? This seems too
> > complex, since we'll need to test for some var on every driver that were
> > converted, providing two KABI options for each converted driver (the legacy
> > and the v4l2_device way). This doesn't seem to be a good idea, since will
> > add a lot of extra complexity to debug bugs.
> 
> Not at the Kconfig level, just in the documentation (and possible headers).

Ah, ok. Good point.

> This is a work in progress. Hans wants the changes to go mainline to get 
> broader testing, which is a valid reason, but I'd like to make sure people 
> understand that more changes are coming.

Maybe instead we should have a TODO list somewhere with the programmed changes,
especially at the subsystem core.

Cheers,
Mauro
