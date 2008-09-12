Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbYILPvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbYILPvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 11:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbYILPvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 11:51:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603AbYILPvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 11:51:00 -0400
Date: Fri, 12 Sep 2008 08:49:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Marcin Obara <marcin_obara@users.sourceforge.net>,
       Jiri Slaby <jirislaby@gmail.com>, tpm@selhorst.net, kjhall@us.ibm.com,
       linux-kernel@vger.kernel.org, srajiv@linux.vnet.ibm.com,
       debora@linux.vnet.ibm.com
Subject: Re: tpm-correct-tpm-timeouts-to-jiffies-conversion.patch -> 2.6.27
Message-Id: <20080912084949.008855e5.akpm@linux-foundation.org>
In-Reply-To: <7218.1221189008@turing-police.cc.vt.edu>
References: <48C84619.8030303@gmail.com>
	<20080910152258.762e3714.akpm@linux-foundation.org>
	<ea8d860a0809110303g68d7cf2fs7affd9103abc9b24@mail.gmail.com>
	<7218.1221189008@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 23:10:08 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Thu, 11 Sep 2008 12:03:52 +0200, Marcin Obara said:
> 
> > > Why?  I wasn't aware that this fixed anything which anyone had observed
> > > (pokes tongue out at the changelog).
> > >
> > 
> > This fixes i.e.: long hang while loading TPM driver, if TPM chip
> > starts in "Idle" state instead of "Ready" state.
> > Without this patch - 'modprobe' may hang for 30 seconds or more.
> > Please, push this patch into 2.6.27.
> 
> I personally don't care whether this goes into .27 or waits till .28.  However,
> I *would* appreciate it if we make sure that whenever it goes go upstream, we
> also send tpm-work-around-bug-in-broadcom-bcm0102-chipset.patch at the same
> time.
> 
> I have to admit that it's not exactly confidence inspiring - if the Broadcom
> chip gets timeout units wrong, what *other* issues lurk in its silicon?  It's
> bad enough when you find bugs in a RAID chipset or mouse hardware - it's even
> worse when it's a security chip.. ;)
> 

hm, it's rather a lot of patching just to fix a once-off 30-second
pause.  On second thoughts, let's do it all in 2.6.28.
