Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbYAIXGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbYAIXGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYAIXGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:06:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbYAIXGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:06:13 -0500
Date: Wed, 9 Jan 2008 23:05:45 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Matt Mackall <mpm@selenic.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080109230545.GG3510@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Chris Friesen <cfriesen@nortel.com>,
	Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
	Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	gorcunov@gmail.com
References: <20080108164015.GC31504@one.firstfloor.org> <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com> <1199909560.6245.67.camel@cinder.waste.org> <20080109224026.GA4039@agk.fab.redhat.com> <20080109224603.GH15612@one.firstfloor.org> <20080109224513.GF3510@agk.fab.redhat.com> <478551A6.9050803@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478551A6.9050803@nortel.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 04:58:46PM -0600, Chris Friesen wrote:
> Alasdair G Kergon wrote:
> >On Wed, Jan 09, 2008 at 11:46:03PM +0100, Andi Kleen wrote:
> >>struct inode *inode = file->f_dentry->d_inode;
> >And oops if that's not defined?
> Isn't this basically identical to what was being passed in to .ioctl()?
 
Not in every case, unless someone's been through and created fake structures in
all the remaining places that pass in a NULL 'file' because there isn't one
available.

Alasdair
-- 
agk@redhat.com
