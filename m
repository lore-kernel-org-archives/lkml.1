Return-Path: <linux-kernel-owner+w=401wt.eu-S933333AbXCHUzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbXCHUzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933338AbXCHUzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:55:54 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:42343 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933333AbXCHUzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:55:53 -0500
Date: Thu, 8 Mar 2007 12:42:21 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Daniel Arai <arai@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       akpm@linux-foundation.org, john stultz <johnstul@us.ibm.com>,
       tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
Message-ID: <20070308204221.GM10574@sequoia.sous-sol.org>
References: <1173313373.24738.937.camel@localhost.localdomain> <45EF6077.9090302@vmware.com> <20070308182456.GH19575@sequoia.sous-sol.org> <45F06720.8080901@goop.org> <20070308194740.GJ10574@sequoia.sous-sol.org> <45F06989.8030207@goop.org> <20070308201033.GK10574@sequoia.sous-sol.org> <45F06FB3.105@goop.org> <20070308202350.GL10574@sequoia.sous-sol.org> <45F07334.7010207@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F07334.7010207@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Maybe hooking into genapic is the right way to mop up all the uses of
> send_IPI and its variants.  But from a quick grep it doesn't look like
> they get called from too many places...  Most of the callers seem to be
> in arch/i386/kernek/smp.c, so they should be pretty easy to isolate.

Yeah, we'll see once we are crashing and debugging some code ;-)
