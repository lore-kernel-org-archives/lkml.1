Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbZBJXRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbZBJXRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 18:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbZBJXRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 18:17:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756751AbZBJXRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 18:17:30 -0500
Date: Tue, 10 Feb 2009 15:17:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: pavel@suse.cz, eric.piel@tremplin-utc.net, linux-kernel@vger.kernel.org,
       palatis@gmail.com
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
Message-Id: <20090210151718.4a8f3421.akpm@linux-foundation.org>
In-Reply-To: <cb7bb73a0902101448h74b6b73j8307c65c4f006152@mail.gmail.com>
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
	<498D9F02.9000107@tremplin-utc.net>
	<cb7bb73a0902071559w70b3367el9471db894872257f@mail.gmail.com>
	<20090209094748.GC4358@atrey.karlin.mff.cuni.cz>
	<cb7bb73a0902090153q30a5337bj45d41a3e3919e189@mail.gmail.com>
	<20090209095803.GD4358@atrey.karlin.mff.cuni.cz>
	<cb7bb73a0902090345y4ef5d544ta374ee96791a80df@mail.gmail.com>
	<cb7bb73a0902090533q3acc45b2r7d00b44aa0bdfc90@mail.gmail.com>
	<20090210101019.GB27018@atrey.karlin.mff.cuni.cz>
	<cb7bb73a0902101339g351bdd8cq442bafbeb7985a00@mail.gmail.com>
	<cb7bb73a0902101448h74b6b73j8307c65c4f006152@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 23:48:14 +0100
Giuseppe Bilotta <giuseppe.bilotta@gmail.com> wrote:

> On Tue, Feb 10, 2009 at 10:39 PM, Giuseppe Bilotta
> <giuseppe.bilotta@gmail.com> wrote:
> > On Tue, Feb 10, 2009 at 11:10 AM, Pavel Machek <pavel@suse.cz> wrote:
> >>
> >> Yeah, that patch. Not sure what to do next... you could grab lis3
> >> manual and see if you can setup chip by hand to get better results...
> >
> > As Eric pointed out, it looks definitely like an endianness problem,
> > although there are a few strange things which are happening at the
> > same time. Is the lis3 manual available online somewhere, or can I
> > request it to the mfgr?
> 
> 'k, found it on the STMicroelectronics website. Reading the doc about
> LIS3LV02DL I see that WHO_AM_I should return 3Ah, but my sensor
> returns 3Bh. I'll see if I find the correct datasheet for this one
> instead, it might have info about the differences.
> 
> One thing that I noticed is that (modulo axis inversion) I'm able to
> use the sensor correctly if I set the thing to only use the high byte,
> totally discarding the lower byte:
> 	return *((s8*)(&hi));
> Maybe this sensor needs a different setup to return 12 instead of 8
> bits of information.
> 

I've lost the plot here.  I still intend to merge
lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models.patch into
2.6.29.  Someone please stop me if that is wrong.

