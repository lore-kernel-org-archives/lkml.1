Return-Path: <linux-kernel-owner+w=401wt.eu-S1763583AbYEBOtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763583AbYEBOtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 10:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYEBOsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 10:48:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:63150 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbYEBOsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 10:48:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=bk8/v25FB81e76lmPDNI5giNtjLrfQ1cXRf5MUiQ2xgBsWeAyox4d6O9dvdWoSdj2TAxX7LCqF3DEMP8Es2NhKzi3tFilIe8r5m/qbSOaCUbebW7P83v+Ho49dOOysaN+NsEacUp3XuWw2Ter6/IIq4Kakcw8kIQ5ZZjdf6184g=
Message-ID: <82e4877d0805020742l7d4a6ec9mc72e79aa3d242348@mail.gmail.com>
Date: Fri, 2 May 2008 10:42:21 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: How to reduce the number of open kernel bugs
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk <at> kernel.org> writes:

> Maintainer:
>
> Yeah, in any case. I cannot fix it, since it's not a bug in the fobar
> code. Please reopen a new bug and CC the architecture or PCI maintainer
> or whatever person related to the bus, chipset or CPU, if you think the
> foobar device still works. If the foobar hardware got corrupted, you
> already know what to do...
>
> I am well aware that loud flames are often the only working way of
> communication in Linux kernel development, but we mustn't communicate
> this way with bug submitters.
>

Actually this way of _communication_ is better because the maintainer has -

a) at least seen the bug
b) made it clear upfront that he/she is not in a position to fix it and
c) not inflicted a huge amount of follow up work for the reporter
while giving no hope that it will be fixed.

There is not much you can do if the maintainer feels he/she can't do
anything - apart from fixing it yourself which has its limits.
So the best that can be done is to communicate it clearly - that
happens in this case.

Compare the above to -

* Reporter reports a bug.

* People in position to fix it  have no care for it and they show it
(By not even looking at it).

* Significant amount of time passes with no activity.

* Reporter receives a automated mail (bonus insult) - New release is
available, please retest with new release and open a new bug if the
problem still exists.

* Bug is closed

* Bug still exists in next release - reporter knows only when he/she
gets a chance to upgrade to next release (not always easy/possible).

Parag
