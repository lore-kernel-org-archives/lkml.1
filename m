Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbXCHUfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbXCHUfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933041AbXCHUfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:35:31 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:45797 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932186AbXCHUfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:35:30 -0500
Date: Thu, 8 Mar 2007 12:23:50 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Daniel Arai <arai@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       akpm@linux-foundation.org, john stultz <johnstul@us.ibm.com>,
       tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
Message-ID: <20070308202350.GL10574@sequoia.sous-sol.org>
References: <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com> <1173313373.24738.937.camel@localhost.localdomain> <45EF6077.9090302@vmware.com> <20070308182456.GH19575@sequoia.sous-sol.org> <45F06720.8080901@goop.org> <20070308194740.GJ10574@sequoia.sous-sol.org> <45F06989.8030207@goop.org> <20070308201033.GK10574@sequoia.sous-sol.org> <45F06FB3.105@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F06FB3.105@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> I guess by "rest of the kernel" you mean other stuff in arch/i386.  Yes,
> that's a concern, but maybe we can tease it apart in a sensible way.

Yes, that's exactly what I'm saying.  Same with above (the native stuff), since
we don't want a bunch of apic_read type of pv_ops (oh, wait... ;-)  Of course,
dom0 will be another can of worms, but one at a time.
