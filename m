Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbXIUBHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbXIUBHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 21:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbXIUBHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 21:07:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbXIUBG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 21:06:59 -0400
Date: Thu, 20 Sep 2007 18:06:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: nigel@suspend2.net
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>, Pavel Machek <pavel@ucw.cz>,
       "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Message-Id: <20070920180623.5d7da7b9.akpm@linux-foundation.org>
In-Reply-To: <200709211024.35991.nigel@nigel.suspend2.net>
References: <1190266447.21818.17.camel@caritas-dev.intel.com>
	<20070920100941.GA12157@atrey.karlin.mff.cuni.cz>
	<200709211024.35991.nigel@nigel.suspend2.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 10:24:34 +1000 Nigel Cunningham <nigel@nigel.suspend2.net> wrote:

> Hi Andrew.
> 
> On Thursday 20 September 2007 20:09:41 Pavel Machek wrote:
> > Seems like good enough for -mm to me.
> > 
> > 									Pavel
> 
> Andrew, if I recall correctly, you said a while ago that you didn't want 
> another hibernation implementation in the vanilla kernel. If you're going to 
> consider merging this kexec code, will you also please consider merging 
> TuxOnIce?
> 

The theory is that kexec-based hibernation will mainly use preexisting
kexec code and will permit us to delete the existing hibernation
implementation.

That's different from replacing it.
