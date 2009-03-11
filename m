Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbZCKWIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbZCKWIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbZCKWHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:07:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42464 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbZCKWHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:07:07 -0400
Date: Wed, 11 Mar 2009 18:07:00 -0400
From: Bill Nottingham <notting@redhat.com>
To: Christopher Brannon <cmbrannon@cox.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
Message-ID: <20090311220700.GA16368@nostromo.devel.redhat.com>
Mail-Followup-To: Christopher Brannon <cmbrannon@cox.net>,
	linux-kernel@vger.kernel.org
References: <20090311200411.WPUP4619.eastrmmtao102.cox.net@eastrmimpo02.cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311200411.WPUP4619.eastrmmtao102.cox.net@eastrmimpo02.cox.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christopher Brannon (cmbrannon@cox.net) said: 
> Under Plan 9 from Bell Labs, one queries or sets the system clock by
> reading or writing text strings to a special file named /dev/time.
> I implemented such a facility for Linux.  A read of /dev/time produces
> four decimal numbers: epoch seconds, nanoseconds since start of epoch,
> nanoseconds since boot, and nanoseconds per second.  Writing a decimal number
> to /dev/time sets the system clock to the given number of epoch seconds.
> Anyone who is permitted to write to /dev/time may set the clock.
> Granting this privilege becomes as easy as modifying groups and file
> permissions.

Given the general array of current interfaces in the kernel, isn't
read/write of textual parameters better suited to sysfs or procfs
than a character device?

Bill
