Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZLWJwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZLWJwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 04:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZLWJw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 04:52:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55681 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbZLWJw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 04:52:28 -0500
Date: Wed, 23 Dec 2009 10:52:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, "Smith, GeoffX" <geoffx.smith@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Michael Stone <michael@laptop.org>
Subject: Re: [PATCH] prctl: return MCE process flags through pointer
Message-ID: <20091223095223.GB20539@basil.fritz.box>
References: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE1829@orsmsx510.amr.corp.intel.com> <87hbricwz8.fsf@basil.nowhere.org> <20091222173424.980d5d33.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091222173424.980d5d33.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 05:34:24PM -0800, Andrew Morton wrote:
> On Wed, 23 Dec 2009 02:14:51 +0100 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > "Smith, GeoffX" <geoffx.smith@intel.com> writes:
> > 
> > > This patch fixes the semantics of prctl() option PR_MCE_KILL_GET 
> > > to pass the return value through *arg2.
> > >
> > > With this change, the option now follows the same conventions as the
> > > other "get" options added since 2.6.0, and also brings it into
> > > conformance with the advice in chapter 16 of Documentation/CodingStyle.
> > >
> > > This prctl() option was only added within the last month, so there are
> > > not any production applications to break.  This patch applies cleanly
> > > to mainline and to 2.6.32.2 for backporting.
> > 
> > It breaks the test suite, the man pages, qemu and one slide deck at least.
> > 
> 
> Should've got it right the first time.

To be honest it's not fully clear to me what is "wrong" with returning
the return value with "return".

If there was a security bug or something maybe such a radical step
as changing a published API would be justified, but for this I'm sceptical.

> 
> What goes wrong with qemu?

It's the main current user of this interface currently.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
