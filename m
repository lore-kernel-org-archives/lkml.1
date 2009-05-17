Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbZEQKZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbZEQKZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 06:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZEQKZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 06:25:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46320 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbZEQKZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 06:25:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sachin Sant <sachinp@in.ibm.com>
Subject: Re: [Bug #13068] Lockdep warining in inotify_dev_queue_event
Date: Sun, 17 May 2009 12:25:34 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <20090517063530.GB1583@elte.hu> <4A0FC736.7050301@in.ibm.com>
In-Reply-To: <4A0FC736.7050301@in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905171225.34911.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 May 2009, Sachin Sant wrote:
> Ingo Molnar wrote:
> > i think this might be fixed by:
> >
> > 381a80e: inotify: use GFP_NOFS in kernel_event() to work around a lockdep false-positive
> >
> > already in -rc6.
> >   
> Haven't seen this issue with rc6.

Great, thanks.  Bug closed.

Best,
Rafael
