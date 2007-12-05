Return-Path: <linux-kernel-owner+w=401wt.eu-S1752453AbXLEI1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbXLEI1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 03:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbXLEI1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 03:27:45 -0500
Received: from osl1smout1.broadpark.no ([80.202.4.58]:56908 "EHLO
	osl1smout1.broadpark.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbXLEI1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 03:27:44 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain
Subject: Re: laptop reboots right after hibernation
From: Kjartan Maraas <kmaraas@broadpark.no>
To: Tejun Heo <htejun@gmail.com>
Cc: Tomas Carnecky <tom@dbservice.com>, Pavel Machek <pavel@ucw.cz>,
       linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-reply-to: <47565738.1050003@gmail.com>
References: <473730F6.2010900@dbservice.com> <20071118105214.GB7299@ucw.cz>
 <4740692E.7010801@dbservice.com> <47409DA3.7070909@dbservice.com>
 <1195551141.2792.3.camel@localhost.localdomain> <474CBFB6.4020105@gmail.com>
 <1196253340.2884.1.camel@localhost.localdomain> <474FE862.4040700@gmail.com>
 <1196458627.4106.1.camel@localhost.localdomain> <47565738.1050003@gmail.com>
Date: Wed, 05 Dec 2007 09:27:18 +0100
Message-id: <1196843238.3289.0.camel@localhost.localdomain>
X-Mailer: Evolution 2.21.2 (2.21.2-4.fc9)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


on., 05.12.2007 kl. 16.46 +0900, skrev Tejun Heo:
> Kjartan Maraas wrote:
> > fr., 30.11.2007 kl. 19.39 +0900, skrev Tejun Heo:
> >> Kjartan Maraas wrote:
> >>> on., 28.11.2007 kl. 10.09 +0900, skrev Tejun Heo:
> >>>> Kjartan Maraas wrote:
> >>>>> I get this exact error message on a normal first time boot here. I'm
> >>>>> using the latest fedora development kernel which is 2.6.24-rc2-git6
> >>>>> based. And I have the latest BIOS from HP IIRC.
> >>>>>
> >>>>> This is an HP nc6400 intel based laptop:
> >>>> Care to post boot dmesg?  Or does harddisk detection fail because of this?
> >>>>
> >>> Here you go. It shows the error two times and then it gets it right and
> >>> continues to boot. No other problems arise from this that I can see.
> >> I'm attaching two patches.  Please apply each on top of clean 2.6.24-rc3
> >> and report kernel boot logs for both.
> >>
> > I tried to do that but recent kernels hang on boot here after TSC:
> > clocksource installed.
> > 
> > Filed a bug here:
> > https://bugzilla.redhat.com/show_bug.cgi?id=405721
> > 
> > but it also happens on the plain rc3 kernel...
> 
> Can you please give a shot at -rc4 kernel?
> 
Sure. It seems the bug above was caused by the compiler and has been
fixed in rawhide now so I'll give it a try.

Cheers
Kjartan


