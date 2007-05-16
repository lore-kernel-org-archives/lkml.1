Return-Path: <linux-kernel-owner+w=401wt.eu-S1761912AbXEPJRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761912AbXEPJRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 05:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbXEPJRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 05:17:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:35956 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbXEPJRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 05:17:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=md++gZSbZHkywWwx0SvWZ90EassDIACGN84BvzNBgf4+XGaGSj5Tn8w/MMCMbV8sFCOdiRho87r9rcEkGlnw7E2VTPfYYRSTIo0RiHKAZn5sGOIB39EJXX+urKGINiOgktKFeefEvGmX/XltFA/vs4gdFb0c1tcXv0f/zG3xMpY=
Message-ID: <a781481a0705160217n1d783d6fk6068e1ac51cf3cc7@mail.gmail.com>
Date: Wed, 16 May 2007 14:47:10 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tilman Schmidt" <tilman@imap.cc>
Subject: Re: Linux 2.6.22-rc1
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
In-Reply-To: <464ACB7E.9040405@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	 <4647569D.7010709@imap.cc>
	 <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>
	 <4648A3DF.7040004@imap.cc>
	 <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr>
	 <a781481a0705141934u6b369dd5ob1715f14890af914@mail.gmail.com>
	 <46498EE3.8010907@imap.cc>
	 <a781481a0705151839l65ea7ee0yb61bf7c911a0c2f8@mail.gmail.com>
	 <464ACB7E.9040405@imap.cc>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/07, Tilman Schmidt <tilman@imap.cc> wrote:
> Am 16.05.2007 03:39 schrieb Satyam Sharma:
> ["default n" for menuconfig]
> > these problems would occur only the _first_ time someone
> > transitions from the old .config's to the new scheme. But those
> > "default y"s for all the various "configmenu"s (let's please call
> > them that) that got introduced in the Kconfig files would cause
> > unnecessary annoyance to users of make oldconfig _for ever_.
>
> I'm not sure I'm following you. Where would that annoyance occur?
> On subsequent uses of "make oldconfig" the default shouldn't even
> matter, as the previous choice would just silently be kept.

Aargh, you're right. The prompt'll come only if it's a "(NEW)"
configmenu addition and hence not come after the first time either.
