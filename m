Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbYFCKqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbYFCKqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbYFCKpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:45:53 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4047 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbYFCKpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:45:52 -0400
Date: Tue, 3 Jun 2008 11:45:38 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, mingo@elte.hu, pavel@suse.cz
Subject: Re: [patch 2.6.26-rc4-git] PM: boot time suspend selftest
Message-ID: <20080603104538.GQ27013@shadowen.org>
References: <200805291333.42057.david-b@pacbell.net> <20080529162257.03426e48.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529162257.03426e48.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 04:22:57PM -0700, Andrew Morton wrote:

> > +static void __init test_wakealarm(struct rtc_device *rtc, suspend_state_t state)
> > +{
> > +	static char		err_readtime [] __initdata =
> > +		KERN_ERR "PM: can't read %s time, err %d\n";
> > +	static char		err_wakealarm [] __initdata =
> > +		KERN_ERR "PM: can't set %s wakealarm, err %d\n";
> > +	static char		err_suspend [] __initdata =
> > +		KERN_ERR "PM: suspend test failed, error %d\n";
> > +	static char		info_test [] __initdata =
> > +		KERN_INFO "PM: test RTC wakeup from '%s' suspend\n";
> 
> - One tab before the variable space is a waste of space.  Two tabs is
>   just extravagant.
> 
> - The space before the [] shouldn't be there.  checkpatch misses this.

Ok, this should be picked up in the next release:

ERROR: space prohibited before open square bracket '['
#1: FILE: Z152.c:1:
+       static char             info_test [] __initdata =

-apw
