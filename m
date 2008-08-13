Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbYHMPYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbYHMPYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 11:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbYHMPYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 11:24:34 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45107 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753561AbYHMPYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 11:24:33 -0400
Date: Wed, 13 Aug 2008 11:24:31 -0400
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26: thinkpad x60 is cooled passively
Message-ID: <20080813152431.GD8232@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20080813080618.GA16061@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813080618.GA16061@elf.ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 10:06:18AM +0200, Pavel Machek wrote:
> While verifying that -rc2 regression is gone, I noticed alarming
> stuff:
> 
> 1) thinkpad x60 relies on passive cooling. You have nice 1.8GHz cpu,
> which goes away as soon as you load it.
> 
> 2) after some time it decides that 100% cpu in 1.0GHz is fine for you,
> and it takes quite long to recover.

There is no fan in the X60?  I didn't think that was the case.  I do
know the fans have a tendency to go bad within 12-18 months, and so
the CPU heat sink and fan unit needs to be replaced perdiocially.
What does /proc/acpi/ibm/fan report? 

Or are you saying that the fan isn't keeping keeping up with the heat
output of the CPU?  Are you sure this isn't due to a hardware problem?
As mentioned previously on this list, Lenovo has had a relatively bad
track record with fan failures and with incompetent installation of
the heat sink with bad applications of the thermal compound; it's the
one failings of an otherwise very nice laptop design.

    	     	   	     	       	      - Ted
