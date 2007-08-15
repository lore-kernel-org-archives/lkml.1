Return-Path: <linux-kernel-owner+w=401wt.eu-S1765750AbXHOSJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765750AbXHOSJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 14:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933419AbXHOSIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 14:08:30 -0400
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:39641 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935136AbXHOSI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 14:08:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=dB848rQpg5rXLMiT4Wl363KxtDMqoKQMlPq5H++mY2C/LLfp9yhlHQ+a5uiMpElV;
  h=Received:Message-ID:Reply-To:From:To:Cc:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE:X-ELNK-Trace:X-Originating-IP;
Message-ID: <000501c7df67$a644c9e0$6501a8c0@earthlink.net>
Reply-To: "Mitchell Erblich" <erblichs@earthlink.net>
From: "Mitchell Erblich" <erblichs@earthlink.net>
To: "Mike Galbraith" <efault@gmx.de>
Cc: <linux-kernel@vger.kernel.org>, <mingo@elte.hu>,
       <dmitry.adamushko@gmail.com>
Subject: Re: QUESTION: RT & SCHED & fork: ?MISSING EQUIV of task_new_fairfor RT tasks.
Date: Wed, 15 Aug 2007 11:10:56 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1106
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec79e86e7dd5060a11d45c77413a24001b19350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.164.86.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> 
> On Tue, 2007-08-14 at 12:28 -0700, Mitchell Erblich wrote:
> > Group, Ingo Molnar, etc,
> >
> > Why does the rt sched_class contain fewer elements than fair?
> > missing is the RT for .task_new.
> 
> No class specific initialization needs to be done for RT tasks.
> 
>         -Mike


Mike, et al,

    one time:  I was told that this group likes bottom posts.

    The logic of class independent code calling class
    scheduling dependent code, assumes that all functions
   are in ALL the class dependent sections.

    Minimally, if I agree with your above statement, I would assume 
    that the function should still exist as a null type function. However,
    in reality,  alot of RT class specific init is done. Just currently 
    none of it is done in this non-existant function.

Mitchell Erblich
