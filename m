Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601Ab0A1PpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab0A1PpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 10:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463Ab0A1PpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 10:45:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab0A1PpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 10:45:03 -0500
Date: Thu, 28 Jan 2010 10:44:48 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [RFC] nmi_watchdog: config option to enable new
 nmi_watchdog
Message-ID: <20100128154448.GV4472@redhat.com>
References: <1264622622-5778-1-git-send-email-dzickus@redhat.com>
 <1264622622-5778-4-git-send-email-dzickus@redhat.com>
 <1264690494.4283.2103.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264690494.4283.2103.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 03:54:54PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-01-27 at 15:03 -0500, Don Zickus wrote:
> > These are the bits that enable the new nmi_watchdog and safely isolate the
> > old nmi_watchdog.  Only one or the other can run, not both at the same
> > time.
> 
> perf disables the lapic watchdog when it wants the pmu, so there
> shouldn't be a problem having both built in.

Yes it does disable but does not prevent nmi_watchdog_tick from running
nor the /proc interface from being loaded.  So perhaps my description
isn't very good.  The idea with the new watchdog was to re-use some of the
bits of the old one, but having them both compiled in seemed to stomp on
each other.  That is what I was trying to prevent.

I can certainly change the behaviour, just makes the code a little more
messy I think.

Cheers,
Don
