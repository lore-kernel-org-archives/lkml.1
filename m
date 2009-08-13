Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbZHMVOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbZHMVOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 17:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbZHMVOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 17:14:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36491 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177AbZHMVOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 17:14:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH update 2x] PM: Introduce core framework for run-time PM of I/O devices (rev. 16)
Date: Thu, 13 Aug 2009 23:14:47 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <200908081625.57333.rjw@sisk.pl> <200908132256.42941.rjw@sisk.pl> <20090813210308.GA9570@linux-sh.org>
In-Reply-To: <20090813210308.GA9570@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908132314.47180.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Paul Mundt wrote:
> On Thu, Aug 13, 2009 at 10:56:42PM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM: Introduce core framework for run-time PM of I/O devices (rev. 16)
> > 
> > Introduce a core framework for run-time power management of I/O
> > devices.  Add device run-time PM fields to 'struct dev_pm_info'
> > and device run-time PM callbacks to 'struct dev_pm_ops'.  Introduce
> > a run-time PM workqueue and define some device run-time PM helper
> > functions at the core level.  Document all these things.
> > 
> > Special thanks to Alan Stern for his help with the design and
> > multiple detailed reviews of the pereceding versions of this patch
> > and to Magnus Damm for testing feedback.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> If there are no more outstanding issues with this, any chance of having
> this rolled in to a topic branch along with Magnus's platform bus
> support? It would be nice if these could spend some time in -next,
> especially as it seems there are no longer any glaring issues with the
> patch series.

I completely agree and I hope there are no major issues with this patch any
more.

If there are no objections, I'm going to put the patch into my linux-next
branch shortly, from where it will go to the for-linus branch.  I'm going to do
that with the Magnus' patch too.

Thanks,
Rafael
