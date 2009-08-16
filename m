Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZHPISO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZHPISO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 04:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZHPISN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 04:18:13 -0400
Received: from mail.lang.hm ([64.81.33.126]:41516 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbZHPISJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 04:18:09 -0400
Date: Sun, 16 Aug 2009 01:18:07 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Theodore Tso <tytso@mit.edu>
cc: David Wagner <daw-news@cs.berkeley.edu>, linux-kernel@vger.kernel.org
Subject: Re: Security: information leaks in /proc enable keystroke recovery
In-Reply-To: <20090816013346.GA17958@mit.edu>
Message-ID: <alpine.DEB.2.00.0908160116330.30426@asgard.lang.hm>
References: <200908152221.n7FMLRuw005799@taverner.cs.berkeley.edu> <20090816003326.GC7554@mit.edu> <h67kou$ahr$1@taverner.cs.berkeley.edu> <20090816013346.GA17958@mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Aug 2009, Theodore Tso wrote:

> On Sun, Aug 16, 2009 at 12:44:14AM +0000, David Wagner wrote:
>> Theodore Tso  wrote:
>>> A configuration option which defaults to disabling ESP and EIP would
>>> be a simple way to prevent this specific instance of information
>>> leakage.  The problem is there are other files that might reveal
>>> timing information, but which are very useful for a system
>>> administrator.  A key example of this is /proc/$pid/wchan, which is
>>> responsible for the WCHAN column is a ps listing.
>>
>> If they're useful for system administrators, would making them
>> readable to root (but not everyone) be enough?
>
> I suppose sysadmins use "sudo ps" instead of "ps", but that would be a
> bit inconvenient and would certainly clutter the sudo logs.  It might
> also cause people to decide it's more trouble than it's worth, and
> configure their system not restrict the various proc files.
>
> That's why I think it would be useful to restrict the number of times
> any process in the system can sample the files before the system
> starts inserting random delays, thus destroying the usefulness of
> using wchan for mounting timing attacks, without removing system
> functionality.

would it make sense to limit the precision of the times reported? or cache 
the results for some time period?

David Lang
