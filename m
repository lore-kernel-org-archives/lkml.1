Return-Path: <linux-kernel-owner+w=401wt.eu-S939995AbXGaDyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939995AbXGaDyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937327AbXGaDyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:54:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:47641 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761845AbXGaDyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:54:08 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: CONFIG_SUSPEND? (was: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1)
Date: Mon, 30 Jul 2007 23:53:18 -0400
User-Agent: KMail/1.9.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <200707251238.50218.lenb@kernel.org> <alpine.LFD.0.999.0707280921150.3442@woody.linux-foundation.org> <alpine.LFD.0.999.0707280932470.3442@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707280932470.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707302353.19217.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 July 2007 12:55, Linus Torvalds wrote:

> So I think the real issue is that we allow that 
> "suspend_devices_and_enter()" code to be compiled without HOTPLUG_CPU in 
> the first place. It's not supposed to work that way.

I don't see how CONFIG_HOTPLUG_CPU justifies its own existence.
This e-mail thread would have never happened if it were simply included
in CONFIG_SMP, always.

I agree, of course, that ACPI should never have had to work-around
this by selecting HOTPLUG_CPU.  But even though it is now done at
the right layer, I don't see why PM should have to
be bothered with selecting HOTPLUG_CPU either --
it should just come with SMP.

-Len
