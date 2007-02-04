Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbXBDVMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbXBDVMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 16:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbXBDVMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 16:12:50 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:23091 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbXBDVMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 16:12:49 -0500
Date: Sun, 4 Feb 2007 13:08:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Eric Piel <Eric.Piel@tremplin-utc.net>
Cc: Dave Jones <davej@redhat.com>, Wang Zhenyu <zhenyu.z.wang@intel.com>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.20-rc7 regression on intel-agp
Message-Id: <20070204130846.d8895f97.randy.dunlap@oracle.com>
In-Reply-To: <45C64960.3080605@tremplin-utc.net>
References: <45C6010A.9010902@tremplin-utc.net>
	<20070204171850.GA17171@redhat.com>
	<45C64960.3080605@tremplin-utc.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Feb 2007 22:00:16 +0100 Eric Piel wrote:

> 04.02.2007 18:18, Dave Jones wrote/a écrit:
> > On Sun, Feb 04, 2007 at 04:51:38PM +0100, Eric Piel wrote:
> >  > Hello,
> >  > 
> >  > I've got a regression in 2.6.20-rc7 (-rc6 was fine) due to commit 
> >  > 4b95320fc4d21b0ff2f8604305dd6c851aff6096 ([AGPGART] intel_agp: restore 
> >  > graphics device's pci space early in resume).
> :
> > 
> > There's an ugly patch below which does the latter. Give it a try?
> Thanks a lot, this made the trick... to some extends at least. I can 
> suspend to disk and resume fine. The framebuffer is not garble neither, 
> however nothing is displayed after resuming :-S Well, it's probably 
> enough to be applied before 2.6.20.

Missed that.  Please send it to stable@kernel.org .

> Attached is the new dmesg, just in case you are interested.
> 
> See you,
> Eric

---
~Randy
