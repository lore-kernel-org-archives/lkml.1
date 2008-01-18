Return-Path: <linux-kernel-owner+w=401wt.eu-S1760885AbYAROXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbYAROXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 09:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756944AbYAROXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 09:23:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38928 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796AbYAROXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 09:23:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: echo mem > /sys/power/state
Date: Fri, 18 Jan 2008 15:26:15 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
References: <20080116222445.6f7ff66e.akpm@linux-foundation.org> <20080118004725.dcd132ee.akpm@linux-foundation.org> <20080118121803.GF11044@elte.hu>
In-Reply-To: <20080118121803.GF11044@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181526.16967.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 18 of January 2008, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > (it doesnt matter if graphics does not resume fine - at least for my 
> > > tests)
> > > 
> > > kprobes had similar problems and it now has a few simple smoke-tests 
> > > - which i just saw trigger on a patch that i did not notice would 
> > > break kprobes. I think this should be done for all functionality 
> > > that is not regularly triggered by a normal distro bootup (and which 
> > > is easy to overlook in testing).
> > 
> > Seeing as we're so lame about being able to distribute userspace 
> > stuff: create a shell script in /proc/rc.kernel and start teaching 
> > initscripts to run it.  Then we can modify it at will.
> 
> would be fine to me.

Yes, that might work.

> The problem isnt just distribution and the tests
> getting out of sync with the kernel (and its capabilities enabled in the 
> .config, etc.), the other problem is unintrusive testing: i for example 
> use unmodified images of various distributions, with only a new bzImage 
> plopped in. That is an intentionally minimal impact test vector, any 
> userspace side changes are discouraged. And that's how many people test 
> new kernels, they just plop it in. The moment we require any userlevel 
> changes, the testing barrier increases significantly.

Very true.

Greetings,
Rafael
