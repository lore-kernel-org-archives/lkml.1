Return-Path: <linux-kernel-owner+w=401wt.eu-S964989AbXDPIRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989AbXDPIRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 04:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965044AbXDPIRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 04:17:13 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:37264 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964989AbXDPIRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 04:17:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r42I2zRuFElYg4+djjVYjDVfRu6RsoFkWa+fKBO+q8YUYPlV6f+8S8RyBXNxlXQuKYDDdJAtLm5UUqWLTaZLoyId9HyTYvFL5wJG9zdKmVPyvjKngbArI67zv/wanhaH1cuq4yE8hipKaCAuhaSqQKv69xORvjx7mSofCn/0vsM=
Message-ID: <d9def9db0704160117te51f4daxc4e92407ed87fddf@mail.gmail.com>
Date: Mon, 16 Apr 2007 10:17:10 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Manu Abraham" <abraham.manu@gmail.com>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB updates
Cc: "Michael Krufky" <mkrufky@linuxtv.org>, linux-dvb-maintainer@linuxtv.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <46230806.7060908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1176653207.10849.5.camel@localhost> <4622C462.8020505@linuxtv.org>
	 <46230806.7060908@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> Michael Krufky wrote:
> > Mauro,
> >
> > I've been out of town for the past few days... I just got home and saw
> this:
> >
> >
> > Mauro Carvalho Chehab wrote:
> >>    - Fix 1/3 for bug 7819: fixed frontend hotplug issue
> >>    - Fix 2/3 for bug 7819: demux and dvr
> >>    - Fix 3/3 for bug 7819: fixed hotplugging for dvbnet
> > I don't think that this is 2.6.21 material.  These patches have not yet
> > received
> > enough testing to be sent to mainline.
> >
> > I have tested them, and they seem to work for my cxusb device, but we have
> > yet to hear test results from users of usb dvb devices that do not use the
> > dvb-usb framework.  (ttusb, flexcop-usb, cinergyT2, for example)
> >
> > The bug that these patches fix has been around throughout the entire
> kernel
> > history of the dvb subsystem.  The bug is not a regression -- it has
> > always been
> > there.  In my opinion, it is too late in 2.6.21 development to apply
> > this change.
> > Because these fixes are not obvious, I think we should let them get some
> > more testing, and have them queued for 2.6.22 .
>
>
> I am not arguing about the veracity of the patches, but how things are
> handled.
>
> Agreed to all the mentioned above. There is one more aspect. The
> mentioned patches, do not have any ACK/SOB from any DVB
> developer/maintainer for the same.
>
> Huge regressions are created this way. One more time the regression
> creator is caught.
>

The patch has been around on the dvb mailinglist ([PATCH][RFC] DVB
Hotplug Fix, 5. April 2007), Michael looked at it when I told him
about it again separatly (12. April 2007)
Between that there was enough time to respond on it or review it.

Mauro told me at the beginning if noone responds he'll go forward
somehow because it fixes hotplugging, and after 2 weeks I wouldn't
expect anyone commenting that thread anymore.

It would be better to look and respond to that patch first before
responding about that you don't like how it's handled, Mauro also
wrote in his announcement that people should look at the recent
mercurial tree and he'll revert it if something doesn't work by
accident before submitting it to his git tree... still noone
complained about the hotplugging patch in there.

Markus
