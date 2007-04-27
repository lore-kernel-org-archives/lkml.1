Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbXD0Pvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbXD0Pvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbXD0Pvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:51:50 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:58927 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbXD0Pvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:51:49 -0400
Date: Fri, 27 Apr 2007 08:55:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Sunil Naidu" <akula2.shark@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Frederik Deweerdt" <deweerdt@free.fr>,
       "Alistair John Strachan" <s0348365@sms.ed.ac.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.21 - something wrong with dmesg.
Message-Id: <20070427085500.1c4b267c.randy.dunlap@oracle.com>
In-Reply-To: <8355959a0704270731k97da30anf1c010f7ae3dc18c@mail.gmail.com>
References: <8355959a0704260514s39afa1ecj3e7e077e482769a8@mail.gmail.com>
	<20070426130339.GB16833@slug>
	<200704261535.46568.s0348365@sms.ed.ac.uk>
	<8355959a0704270731k97da30anf1c010f7ae3dc18c@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 20:01:37 +0530 Sunil Naidu wrote:

> On 4/26/07, Alistair John Strachan <s0348365@sms.ed.ac.uk> wrote:
> > >
> > > Don't you need to increase CONFIG_LOG_BUF_SHIFT ?
> 
> Yep, I need to. But, have to enable the Kernel Debug (DEBUG_KERNEL) to
> increase the value from default 14 value to 15/16. I feel that this
> might increase the kernel size?
> 
> Ummm, is it possible to move CONFIG_LOG_BUF_SHIFT under the General
> Setup area? (say, down the Kernel .config support - IKCONFIG).
> 
> Comments pl?

Yes, that would be OK.  Can you submit a patch for that?

> > (Also, does Andrew really need to be CCed twice?)
> 
> I agree with you - my apologies to Andrew ;-) (shall bug him @ linux
> foundation only)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
