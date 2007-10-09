Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbXJIPMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbXJIPMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 11:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbXJIPMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 11:12:00 -0400
Received: from lixom.net ([66.141.50.11]:52368 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbXJIPL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 11:11:59 -0400
Date: Tue, 9 Oct 2007 10:17:02 -0500
From: Olof Johansson <olof@lixom.net>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Lord <mlord@pobox.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch 09/12] Fix SMP poweroff hangs
Message-ID: <20071009151702.GA19209@lixom.net>
References: <20071008180406.052382073@mini.kroah.org> <20071008180633.GJ7627@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071008180633.GJ7627@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 11:06:33AM -0700, Greg KH wrote:
> From: Mark Lord <lkml@rtr.ca>
> 
> commit 4047727e5ae33f9b8d2b7766d1994ea6e5ec2991 from upstream
> 
> We need to disable all CPUs other than the boot CPU (usually 0) before
> attempting to power-off modern SMP machines.  This fixes the
> hang-on-poweroff issue on my MythTV SMP box, and also on Thomas Gleixner's
> new toybox.

Paul Mackerras has reported crashes when rebooting some older ppc64
systems due to this patch.

See http://ozlabs.org/pipermail/linuxppc-dev/2007-October/043969.html.


-Olof

