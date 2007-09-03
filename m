Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbXICQ5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbXICQ5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 12:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbXICQ5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 12:57:36 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:14377 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbXICQ5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 12:57:35 -0400
Date: Mon, 3 Sep 2007 09:57:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stefan Becker <Stefan.Becker@nokia.com>
Cc: linux-kernel@vger.kernel.org, michal.k.k.piotrowski@gmail.com
Subject: Re: [pre-2.6.23 REGRESSION] 2.6.23-rc3-git1 crash/stuck on VIA
 CN700 system
Message-Id: <20070903095713.3d071275.randy.dunlap@oracle.com>
In-Reply-To: <46DBA2DE.9040803@nokia.com>
References: <46C9D148.5080505@nokia.com>
	<46D3AF72.7030701@nokia.com>
	<46DBA2DE.9040803@nokia.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Sep 2007 08:59:58 +0300 Stefan Becker wrote:

> Hi,
> 
> > Stefan Becker wrote:
> >>
> >> while trying to debug a hibernation/rtc_cmos alarm wakeup problem in 
> >> 2.6.22 (or later) I noticed that the latest kernel crashes (or gets 
> >> stuck sometimes) during boot after the message:
> >>
> >> SMP alternatives: switching to UP code
> 
> Retested with 2.6.23-rc4. Same result.
> 
> I also added "debug" to the boot command line. Unfortunately it didn't 
> show anything new. Comparing to 2.6.22.2 boot the next message should be
> 
>   Freeing SMP alternatives: ....
> 
> Any hints what I should change on the command line or config to reveal 
> more information?

You could try booting with 'initcall_debug' to see if that helps
narrow down the error.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
