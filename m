Return-Path: <linux-kernel-owner+w=401wt.eu-S1031164AbXEALK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031164AbXEALK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 07:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031168AbXEALK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 07:10:28 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:46370 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031164AbXEALK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 07:10:27 -0400
Date: Tue, 1 May 2007 13:09:33 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: nigel@nigel.suspend2.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: VMware, x86_64 and 2.6.21.
In-Reply-To: <b6a2187b0704302313p4cb7924bj506d68a1c1b6fb41@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705011309050.18504@yvahk01.tjqt.qr>
References: <1177998147.8981.16.camel@nigel.suspend2.net>
 <b6a2187b0704302313p4cb7924bj506d68a1c1b6fb41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 1 2007 14:13, Jeff Chua wrote:
> On 5/1/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
>> Hi.
>> 
>> Does anyone have VMware working on x86_64 with 2.6.21? It's working fine
>> for me with 2.6.20, but freezes the whole computer with 2.6.21. Before I
>
>
> I'm on i386 and noticed it makes the "guest" very unresponsive.
>
> Uncheck "disable write-caching" solves the problem.

Why do you even have "disable wc" turned _on_? (Yes, it's a VMware 5 bug where
it gets randomly set upon machine creation, VM WS 6 has it fixed.)


Jan
-- 
