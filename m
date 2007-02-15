Return-Path: <linux-kernel-owner+w=401wt.eu-S966057AbXBOQXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966057AbXBOQXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966061AbXBOQXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:23:08 -0500
Received: from inetc.connecttech.com ([64.7.140.42]:2648 "EHLO
	inetc.connecttech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966057AbXBOQXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:23:07 -0500
From: "Stuart MacDonald" <stuartm@connecttech.com>
To: "'v j'" <vj.linux@gmail.com>, "'Randy Dunlap'" <rdunlap@xenotime.net>
Cc: "'Dave Jones'" <davej@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: RE: GPL vs non-GPL device drivers
Date: Thu, 15 Feb 2007 11:22:38 -0500
Organization: Connect Tech Inc.
Message-ID: <000001c7511d$829e91c0$294b82ce@stuartm>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
Importance: Normal
In-Reply-To: <9b3a62ab0702142328h87365b6i932d4f2c117f7f0e@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2180
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: On Behalf Of v j
> On 2/14/07, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > We seem to have different definitions of open and closed.
> 
> Open = 3rd party Linux drivers can be loaded. Closed = No third party
> Linux drivers can be loaded.

That is BSD-openness; the freedom to do anything with the code you
receive, including making it so that others who receive modified code
from you *don't* have the same freedom.

Linux is GPLed, and thus uses GPL-openness:
Open = All source code is available to all, so that the code may
survive and freedoms be preserved. Closed = Non-available source code.

This ensures that others who receive modified code from you also
receive the same freedoms you received.

From: On Behalf Of v j
> Sent: February 15, 2007 12:39 AM
> No its not. It wasn't common knowledge 3 years ago when we chose Linux
> as an embedded platform. If it indeed is common knowledge that
> loadable modules in Linux have to be open-source then it is very
> probable that we wouldn't have chosen Linux as the platform of choice.

Counter-example: we've been using uClinux in an embedded system since
2002, over 4 years. It was common knowledge at that time that many
people, including some lawyers, considered drivers to be a derived
work of the kernel and thus the GPL would apply to them. That's how I
found out about it.

Linus does allow for one exception; drivers written for other OSes
that happen to compile for Linux as well. I believe this is the POSIX
exception mentioned elsethread. However, from your description of
requiring GPL-only symbols, I'm pretty sure your driver is a derived
work. Since you're distributing it (inside your device), the code must
be made available, under the GPL.

You also asserted that the code is only useful to your competitors.
That simply is not true. No company suppports a product forever, even
if they believe they will. Once that support is gone, the only way to
fix bugs or improve the product is to **have the code in hand**. THAT
is what the GPL-openness is all about. THAT is when the code is useful
to the open source community at large. Since that need is inevitable,
the code must be provided up-front, when distribution starts.

..Stu

