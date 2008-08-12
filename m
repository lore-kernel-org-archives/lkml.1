Return-Path: <linux-kernel-owner+w=401wt.eu-S1751817AbYHLFbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbYHLFbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 01:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbYHLFbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 01:31:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbYHLFbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 01:31:14 -0400
Date: Mon, 11 Aug 2008 22:30:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linuxfoundation.org,
       fritz@isdn4linux.de, kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] ISDN: make ICN not auto-grab port 0x320
Message-Id: <20080811223043.9ad55c51.akpm@linux-foundation.org>
In-Reply-To: <48A11952.6090203@keyaccess.nl>
References: <489DD669.2090207@keyaccess.nl>
	<20080809215020.1bb602e7@lxorguk.ukuu.org.uk>
	<20080811164814.db41c20b.akpm@linux-foundation.org>
	<48A11952.6090203@keyaccess.nl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 07:02:10 +0200 Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 12-08-08 01:48, Andrew Morton wrote:
> 
> > otoh it's a bit sad to break allyesconfig kernels - there is
> > regression-testing value in being able to run such kernels.
> > 
> > I wonder if we can add a new boot option `allyesconfig-test' or
> > something like that, and then, within the offending drivers, test that
> > flag and take suitable avoiding action.
> > 
> > Or we could do it at compile-time - define
> > CONFIG_ALLYESCONFIG_TESTING in some fashion.
> 
> Yes, latter I'd feel with the thing most against it that there aren't 
> actually many that need it.

I think the boot option is the way, if at all.

Because the config option isn't very usable.  What's to stop someone
from doing `make allyesconfig' and then menually editing the .config so
it's no longer truly an allyesconfig .config?

otoh, if is't purely a manual setting rather than some automagic thing
then it might be workable.  CONFIG_INGO :)
