Return-Path: <linux-kernel-owner+w=401wt.eu-S1751525AbYCCLrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbYCCLrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 06:47:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbYCCLqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 06:46:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43579 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYCCLqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 06:46:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: linux-v2.6.25-rc3 issue: nvidiafb: cannot ioremap FB base
Date: Mon, 3 Mar 2008 12:45:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       mingo@elte.hu, "Andrew Morton" <akpm@linux-foundation.org>
References: <38b2ab8a0802280607h46a89f04wdd190a7c87571668@mail.gmail.com> <200803022039.51634.rjw@sisk.pl> <38b2ab8a0803030006m577304c1wcb57b32e62da6170@mail.gmail.com>
In-Reply-To: <38b2ab8a0803030006m577304c1wcb57b32e62da6170@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031245.50967.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 3 of March 2008, Francis Moreau wrote:
> On Sun, Mar 2, 2008 at 8:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday, 1 of March 2008, Francis Moreau wrote:
> >  > Ok,
> >  >
> >  > After spending (too much) time to bisect this, I found that the looser
> >  > commit is:
> >  >
> >  > c31c7d4844ea4817692ae16bf70f9c96c05a50eb
> >  > [ x86: CPA, fix alias checks ]
> >
> >  Please add yourself to the CC list of the Bugzilla entry at:
> >  http://bugzilla.kernel.org/show_bug.cgi?id=10140
> >
> 
> OK, done.

Thanks.

The commit that causes the breakage is going to be reverted.

Rafael
