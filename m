Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbZCMGEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbZCMGEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 02:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZCMGEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 02:04:40 -0400
Received: from kroah.org ([198.145.64.141]:51579 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750979AbZCMGEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 02:04:39 -0400
Date: Thu, 12 Mar 2009 22:56:54 -0700
From: Greg KH <greg@kroah.com>
To: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Stable Kernel <stable@kernel.org>
Subject: Re: [stable] [Bug #12766] Lots of smp_processor_id() in
	preemptible messages
Message-ID: <20090313055654.GC11965@kroah.com>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera> <vP9hdyF4fL.A.-rC.vozoJB@chimera> <49A34777.3050809@goop.org> <49A4365A.8080704@phoenixsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A4365A.8080704@phoenixsoftware.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 07:03:06PM +0100, Tilman Schmidt wrote:
> Jeremy Fitzhardinge schrieb:
> >>
> >> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=12766
> >> Subject        : Lots of smp_processor_id() in preemptible messages
> >> Submitter    : Tilman Schmidt <t.schmidt@phoenixsoftware.de>
> >> Date        : 2009-02-23 18:37 (1 days old)
> >> References    : http://marc.info/?l=linux-kernel&m=123541536414019&w=4
> > 
> > Looks like stable needs to pick up 
> > d85cf93da66977dbc645352be1b2084a659d8a0b.
> 
> I can confirm that commit d85cf93da66977dbc645352be1b2084a659d8a0b applied to 2.6.28.7 fixes this.

Now queued up in 2.6.28-stable
