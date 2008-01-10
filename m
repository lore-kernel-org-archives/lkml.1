Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYAJLk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYAJLk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 06:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYAJLkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 06:40:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbYAJLkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 06:40:08 -0500
Date: Thu, 10 Jan 2008 11:39:54 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: Matt Mackall <mpm@selenic.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080110113954.GL3510@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Daniel Phillips <phillips@phunq.net>,
	Matt Mackall <mpm@selenic.com>,
	Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, gorcunov@gmail.com
References: <20080108164015.GC31504@one.firstfloor.org> <1199909560.6245.67.camel@cinder.waste.org> <20080109224026.GA4039@agk.fab.redhat.com> <200801100149.16301.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801100149.16301.phillips@phunq.net>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 01:49:15AM -0800, Daniel Phillips wrote:
> So what stops you from changing to unlocked_ioctl for the main device 
> mapper ctl_ioctl?  

Nothing - patches to do this are queued for 2.6.25:

  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-ioctl-remove-lock_kernel.patch
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-ioctl-move-compat-code.patch

Alasdair
-- 
agk@redhat.com
