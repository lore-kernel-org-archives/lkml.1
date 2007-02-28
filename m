Return-Path: <linux-kernel-owner+w=401wt.eu-S932137AbXB1LIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbXB1LIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 06:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932136AbXB1LIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 06:08:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40644 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbXB1LIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 06:08:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: vatsa@in.ibm.com
Subject: Re: Problem with freezable workqueues
Date: Wed, 28 Feb 2007 12:09:04 +0100
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <200702272251.28844.rjw@sisk.pl> <20070228084859.GB104@tv-sign.ru> <20070228091053.GA15509@in.ibm.com>
In-Reply-To: <20070228091053.GA15509@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702281209.05512.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 February 2007 10:10, Srivatsa Vaddagiri wrote:
> On Wed, Feb 28, 2007 at 11:48:59AM +0300, Oleg Nesterov wrote:
> > On 02/28, Srivatsa Vaddagiri wrote:
> > > We can just thaw the worker thread selectively before kthread_stopping
> > > them. This will let us freeze all worker threads (which we want to for
> > > hotplug anyway).
> > 
> > I am not sure this is a good change for 2.6.21.
> 
> So we make that change when merging the freezer-based hotplug patchset?

Well, if we want to have freezable workqueues eventually, and I think we do,
they should be taken into consideration in designing this patchset, as well as
the suspend code ordering (ie. freeze_processes(SUSPEND) before
freeze_processes(CPU_HOTPLUG)).

Greetings,
Rafael
