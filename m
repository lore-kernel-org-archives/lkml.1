Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbZG2Vse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbZG2Vse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 17:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZG2Vsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 17:48:33 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:60204 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZG2Vsd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:48:33 -0400
Date: Wed, 29 Jul 2009 23:48:32 +0200
Message-Id: <845142195@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Tomas Carnecky <tom@dbservice.com>
Subject: Re: Show module version sysfs file for built-in modules?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18jye0n/nuv8kjWIVvVt8hW1nnSVYbn8EOdIg0PsTed9NS6e
 EedOq3PZBjkfEGCeEoy3EACNK43eWrbclp7fqmcqCTZJgTudGM=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pardon - that was dumb.
must have read over that built-in.

indeed, this is a missing feature. 
there are even modules/drivers which don´t spit any line in dmesg when they are initialized - builtin or not.
there is a LOT of different behaviour in module load/init and i`d welcome if module initialization messages including version information would follow a more standard way. many modules don`t even have a version.

regards
roland


> -----Ursprüngliche Nachricht-----
> Von: "Alan Jenkins" <sourcejedi.lkml@googlemail.com>
> Gesendet: 29.07.09 21:10:24
> An: devzero@web.de
> CC: Tomas Carnecky <tom@dbservice.com>, linux-kernel@vger.kernel.org
> Betreff: Re: Show module version sysfs file for built-in modules?


> On 7/29/09, devzero@web.de <devzero@web.de> wrote:
> > what about this ?
> >
> > neoware:/sys/module/8139too # cat /sys/module/8139too/version
> > 0.9.28
> >
> > neoware:/sys/module/8139too # modinfo 8139too |grep "^version:"
> > version:        0.9.28
> >
> > the latter should work completely without consulting the kernel for that
> > information.
> >
> > regards
> > roland
> >
> >>List:       linux-kernel
> >>Subject:    Show module version sysfs file for built-in modules?
> 
> modinfo clearly won't work for *built in* drivers.  Apparently
> /sys/module/$MODULE/version doesn't work for built in modules either.
> Hence this proposal.
> 
> Alan
> 


______________________________________________________
GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

