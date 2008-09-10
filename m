Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbYIJTou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbYIJTou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYIJTol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:44:41 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:42633 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYIJTok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:44:40 -0400
Message-ID: <48C82376.8020804@diamondcut.com.br>
Date: Wed, 10 Sep 2008 16:43:50 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: multinymous@gmail.com, Elias Oltmanns <eo@nebensachen.de>,
       Thomas Renninger <trenn@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>, roy@marples.name
Subject: Re: Laptop shock detection and harddisk protection
References: <48C7FCEE.8060404@kernel.org>
In-Reply-To: <48C7FCEE.8060404@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo escreveu:
> I browsed a little bit for HDAPS one and it seems all the pieces are
> there but scattered.  The latest effort seems tp_smapi which Shem
> Multinymous is working on.

I have a Lenovo Thinkpad T61 running tp_smapi and hdapsd over 2.6.26.2
Kernel with Elias patch:
<http://article.gmane.org/gmane.linux.drivers.hdaps.devel/1324/raw>

If you need some info, pls let me know.

> 1. How should the shock interface look like?  As we're gonna need
>    userland daemon one way or the other, we can use the userland
>    daemon to glue all the interfaces but it would be much better to
>    have a unified interface.  Although there seem to be several
>    different variants, they don't differ all that much and creating a
>    new interface every time is painful.  I think we can get by with a
>    sysfs interface with notification.

IMHO, userland daemon need only inform users when hdd heads was parking.
This is what KHDAPSMonitor do (<http://roy.marples.name/node/269>).
A daemon like this is used in Windows, but one more feature is present:
Is possible choose "Manual Unlock" (hdd heads is kept parked until I
click over daemon to unlock).

Best regards,
Renato S. Yamane
