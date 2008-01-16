Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbYAPLvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbYAPLvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 06:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYAPLv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 06:51:28 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:12378 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYAPLv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 06:51:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GgYuWpcfcAaxpxHLJiJWpiJ+ljSq4poHSYpPEAL96iK3dujZs6gr5xtHLw5MENHM7MrJLMVT1BQps5+mWbUDyCKYkyo1Y29NOmBSLEOveZQi1P8WZxVMqdD07W6LEEsFCIyXt3vdOA6gStylhxUawzGWCNTE9HqtKl2ECUmNG8Y=
Message-ID: <cfd9edbf0801160351i2b819f31j65cc16b1e694168f@mail.gmail.com>
Date: Wed, 16 Jan 2008 12:51:26 +0100
From: "=?ISO-8859-1?Q?Daniel_Sp=E5ng?=" <daniel.spang@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 3/5] add /dev/mem_notify device
Cc: "Marcelo Tosatti" <marcelo@kvack.org>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080116114234.GA22460@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080115100029.1178.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080115221627.GC1565@elf.ucw.cz>
	 <20080116105102.11B1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080116041332.GA30877@dmt> <20080116114234.GA22460@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/16/08, Pavel Machek <pavel@ucw.cz> wrote:
> On Wed 2008-01-16 02:13:32, Marcelo Tosatti wrote:
> > On Wed, Jan 16, 2008 at 10:57:16AM +0900, KOSAKI Motohiro wrote:
> > > Hi Pavel
> > >
> > > > >         err = poll(&pollfds, 1, -1); // wake up at low memory
> > > > >
> > > > >         ...
> > > > > </usage example>
> > > >
> > > > Nice, this is really needed for openmoko, zaurus, etc....
> > > >
> > > > But this changelog needs to go into Documentation/...
> > > >
> > > > ...and /dev/mem_notify is really a bad name. /dev/memory_low?
> > > > /dev/oom?
> > >
> > > thank you for your kindful advise.
> > >
> > > but..
> > >
> > > to be honest, my english is very limited.
> > > I can't make judgments name is good or not.
> > >
> > > Marcelo, What do you think his idea?
> >
> > "mem_notify" sounds alright, but I don't really care.
> >
> > Notify:
> >
> > To give notice to; inform: notified the citizens of the curfew by
> > posting signs.
>
> I'd read mem_notify as "tell me when new memory is unplugged" or
> something. /dev/oom_notify? Plus, /dev/ names usually do not have "_"
> in them.

I don't think we should use oom in the name, since the notification is
sent long before oom.
