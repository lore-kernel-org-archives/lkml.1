Return-Path: <linux-kernel-owner+w=401wt.eu-S1761435AbXF2JnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435AbXF2JnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 05:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbXF2JnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 05:43:09 -0400
Received: from www19.your-server.de ([213.133.104.19]:37382 "EHLO
	www19.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbXF2JnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 05:43:08 -0400
From: Uli Luckas <u.luckas@road.de>
Organization: Road GmbH
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: Mounting MMC card
Date: Fri, 29 Jun 2007 11:42:50 +0200
User-Agent: KMail/1.9.7
Cc: "Midhun Agnihotram" <agnimidhun@gmail.com>,
       "Pierre Ossman" <drzeus-mmc@drzeus.cx>,
       "=?iso-8859-1?q?Hans-J=FCrgen?= Koch" <hjk@linutronix.de>, jdi@l4x.org
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com> <4684CDCC.9030202@drzeus.cx> <4dde4acb0706290230g6a38f0cds47b0d76216f861e6@mail.gmail.com>
In-Reply-To: <4dde4acb0706290230g6a38f0cds47b0d76216f861e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706291142.50893.u.luckas@road.de>
X-Authenticated-Sender: webmaster@road.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 29. June 2007, Midhun Agnihotram wrote:
> Hi All,
>
> > Let's try something a lot less complex than mounting. Try running:
> >         dd if=/dev/mmcblk0 of=/dev/null count=100
>
>     Here goes the output(error).
>
> / # dd if=/dev/mmcblk0 of=/dev/null count=100
> dd: can't open '/dev/mmcblk0': No such device or address
>
>     The /dev is has the following:
>
> / # ls -l /dev | grep mmc
> brwxrwxrwx    1 0        0        254,   0 Jun 26  2007 mmcblk0
> brwxrwxrwx    1 0        0        254,   1 Jun 26  2007 mmcblk0p0
> brwxrwxrwx    1 0        0        254,   2 Jun 26  2007 mmcblk0p1
> brwxrwxrwx    1 0        0        254,   3 Jun 26  2007 mmcblk0p2
> brwxrwxrwx    1 0        0        254,   4 Jun 26  2007 mmcblk0p3
>
If I remember correctly, mmc devices did not have fixed majors/minors 
allocated until recently. Either get a recent kernel or use some kind of 
hotplug (udev) scripts to create your device nodes with dynamically allocated 
major/minors.

Regards
Uli



-- 

------- ROAD ...the handyPC Company - - -  ) ) )

Uli Luckas
Software Development

ROAD GmbH
Bennigsenstr. 14 | 12159 Berlin | Germany
fon: +49 (30) 230069 - 64 | fax: +49 (30) 230069 - 69
url: www.road.de

Amtsgericht Charlottenburg: HRB 96688 B
Managing directors: Hans-Peter Constien, Hubertus von Streit
