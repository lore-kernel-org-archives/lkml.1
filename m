Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbXCVNxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbXCVNxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 09:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932341AbXCVNxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 09:53:23 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:44119 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627AbXCVNxW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 09:53:22 -0400
Date: Thu, 22 Mar 2007 14:53:19 +0100
Message-Id: <1695154679@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Subject: Re: max_loop limit
Organization: http://freemail.web.de/
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

oh - i forgot sending this to the list, since this was copy&paste via webmailer.....


> -----Ursprüngliche Nachricht-----
> Von: devzero@web.de
> Gesendet: 22.03.07 14:42:45
> An: tomas@slax.org
> CC: breeves@redhat.com
> Betreff: Re: max_loop limit

> Hi Tomas, 
> 
> you`re completely right.
> 
> I have had this problem of loopdev number limitation for years, but i think there is a better solution besides your patch.
> 
> Some new module has been created for this and being announced on dm-devel mailinglist : 
> 
> dm-loop - the device mapper loopback target.
> 
> See http://sources.redhat.com/lvm2/wiki/DMLoop  for further information.
> 
> It can be used as a 1:1 replacement for classic loop and should (?) probably be ready for mainline in the not too far future. (i cannot tell, but it works good for me!)
> 
> Typically, you need to use dm-setup to setup device-mapper targets, but dm-setup has got support for dm-loop,  so it`s as easy as 1-2-3 to replace "losetup ...." with "dmlosetup" alias for dm-setup.
> 
> Feel free to test it and give feedback !
> 
> regards
> Roland
> 
> ps:
> dm-loop-config.patch is being linked wrong in the wiki - this is the right one:  http://sources.redhat.com/lvm2/wiki/DMLoop?action=AttachFile&do=get&target=dm-loop-config.patch
> 
> 
> 
> > 255 loop devices are insufficient? What kind of scenario do you have
> > in mind?
> > 
> > 
> 
> Thank you very much for replying.
> 
> In 1981, Bill Gates said that 64KB of memory is enough for everybody.
> And you know how much RAM do you have right now. :)
> 
> Every limit is bad. The limit of 255 loop devices has been introduced 
> years ago, in the times when minor device number has been limited by 
> 255. Nowadays, there is no such limitation.
> 
> There are many possible/reasonable uses for more than 255 loop devices. 
> For example CD/ISO server. My project, Slax Linux live, is based on 
> modular approach where many parts of the root filesystem are stored 
> separately in compressed read-only loop files, and are mounted and 
> unioned to a single root by using union fs (aufs).
> 
> The question is not "Why do we need more than 255 loops?".
> The question should be "Why do we need the hardcoded 255-limit in kernel 
> while there is no reason for it at all?"
> 
> My patch simply removes the hardcoded limitation.
> 
> 
> Tomas M
> slax.org


_______________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192

