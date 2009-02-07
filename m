Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbZBGUsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbZBGUsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 15:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZBGUsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 15:48:24 -0500
Received: from mail.gmx.net ([213.165.64.20]:53735 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753571AbZBGUsX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 15:48:23 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18Dm2c+OMwDV5IcddywQs2podaqkDgczEMyTUUK/T
	0rkeJTvvl8PhGG
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: cpu frequency maximized even for a niced job w/ v2.6.29-rc3
Date: Sat, 7 Feb 2009 21:48:19 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <200902071130.10463.toralf.foerster@gmx.de> <20090207115545.724911be@infradead.org>
In-Reply-To: <20090207115545.724911be@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902072148.19953.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At Saturday 07 February 2009 20:55:45 Arjan van de Ven wrote :
> On Sat, 7 Feb 2009 11:30:10 +0100
>
> Toralf Förster <toralf.foerster@gmx.de> wrote:
> > I'm wondering, why my ThinkPad T41 goes from 600 MHz to 1.7 GHz if I
> > run this job :
> >
> > $> while [[ true ]]; do nice -3 factor 273244676154386297; done
> >
> > under v2.6.29-rc3-562-geda58a8.
> >
> > Former version stays at min frequency (600 MHz).
>
> The kernel has defaulted to this for I think a really long time;
> maybe your "former version" was a distribution kernel with patches?
>
> Either way this is a simple tunable in sysfs; and to be honest,
> going to the full speed is very often the right behavior so as a
> default it is quite sane...
Oh - maybe I for got to mention that I set ./ondemand/ignore_nice_load to "1"


-- 
MfG/Sincerely

Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

