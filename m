Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbXDKOlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbXDKOlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 10:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbXDKOlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 10:41:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37451 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbXDKOlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 10:41:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [PATCH] kthread: Don't depend on work queues
Date: Wed, 11 Apr 2007 16:44:52 +0200
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com
References: <20070410185133.GA104@tv-sign.ru> <20070411114805.GA165@tv-sign.ru> <20070411133139.GB10623@in.ibm.com>
In-Reply-To: <20070411133139.GB10623@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704111644.53280.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 11 April 2007 15:31, Gautham R Shenoy wrote:
> On Wed, Apr 11, 2007 at 03:48:05PM +0400, Oleg Nesterov wrote:
> > On 04/11, Gautham R Shenoy wrote:
> > >
> > > On Wed, Apr 11, 2007 at 12:13:34PM +0200, Rafael J. Wysocki wrote:
> > > > 
> > > > It should be calling try_to_freeze() somewhere anyway.  We may need to freeze
> > > > all tasks in some cases.
> > > 
> > > How about
> > > for (;;) {
> > > 	try_to_freeze();
> > > 
> > > ?
> > 
> > Why?
> 
> If some event (defintely NOT cpu hotplug) needs this thread frozen.

I didn't mean the CPU hotplug too, BTW, but I'm considering freezing all tasks
at the late stage of suspend (ie. after freezing devices).

Greetings,
Rafael
