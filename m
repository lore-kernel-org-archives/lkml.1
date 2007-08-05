Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbXHER6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbXHER6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 13:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXHER60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 13:58:26 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:8376 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752026AbXHER6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 13:58:25 -0400
Message-ID: <46B60FB7.8030301@interia.pl>
Date: Sun, 05 Aug 2007 19:58:15 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
References: <200708031903.10063.jimis@gmx.net> <200708051903.12414.jimis@gmx.net>
In-Reply-To: <200708051903.12414.jimis@gmx.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: ec9e6acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello again,
Hi! 
> was my report so complicated? Perhaps I shouldn't have included so many 
> oprofile outputs. Anyway, if anyone wants to have a look, the most important 
> is two_discs_bad.txt oprofile output, attached on my original message. The 
> problem is 100% reproducible for me so I would appreciate if anyone told me 
> he has similar experiences. 
Probably nobody replied to Your message because people at this list think 
that Your problem isn't kernel related. In this moment I'm using "Arch Linux" 
too, so I checked /etc/cron directory. There simple jobs You are talking 
about are not so simple:
- update the "locate" database,
- update the "whatis" database.
Both jobs are scaning "/" partition. I don't know how dcron works, but I can 
imagine situation in which it is polling cron.daily and says: "hey it wasn't 
done today yet" and it is starting same jobs over and over again. More 
and more tasks scans the "/" partition and in result access is slower and 
slower.
> 
> Thanks, 
> Dimitris
Let me know if I'm wrong
Rafał


----------------------------------------------------------------------
Zmien konto na takie o nieograniczonej pojemnosci.
Za darmo w INTERIA.PL

>>>http://link.interia.pl/f1b0a

