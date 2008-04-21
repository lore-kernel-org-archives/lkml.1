Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbYDUXjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbYDUXjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbYDUXiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:38:52 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:40218 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbYDUXiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:38:52 -0400
Date: Tue, 22 Apr 2008 01:38:49 +0200
Message-Id: <248552034@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: bunk@kernel.org, mingo@elte.hu
Subject: Re: [2.6 patch] remove the v850 port
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX188eMSxmTRawvCU1sgsq+MZH3Cdoc+jAVZsCBvp4KhY5mWid
 qcwqpeJQrpan9M92WtZvXXeJPEwuuLBYebQqwmwJptbob3yta0=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't afford to be critical here, but let me give a comment.

i think putting this in feature-removal-schedule.txt just good practice.
you give people the chance to catch up - sort of a last reminder to the devs "fix it or we need to drop it".
some chance for the users to see it will go away and make early decision based on that.

i like those cleanup efforts, but even if it was announced on lkml, or elsewhere - that file is the official place for such announcements and if you want people take care of that file, there should be reliable information inside. 

it often takes much effort and hard work to get code into the kernel, so some "nah, this is broken, doesn`t compile for long - put that to trash" seems a little bit harsh for me.

the reason why it`s broken is probably not the v850 people`s fault. 
ok, they just didn`t catch up with that "kernel progress" - but most probably some other person broke their code.

i don`t like bureaucracy, but a little bit of bureaucracy at the right place is not that bad at all.....

roland


> start by putting the intention of removal into:
> 
>    Documentation/feature-removal-schedule.txt
> 
> we can remove it after that. Same for most of your other removal 
> patches.

Why?

> 	Ingo

cu
Adrian
_________________________________________________________________________
In 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten! 
Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=021114

