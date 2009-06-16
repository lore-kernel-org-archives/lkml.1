Return-Path: <linux-kernel-owner+w=401wt.eu-S1760505AbZFPRN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505AbZFPRN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758532AbZFPRNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:13:50 -0400
Received: from www17.your-server.de ([213.133.104.17]:49811 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbZFPRNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:13:49 -0400
Subject: Re: 2.6.30: suspend-to-ram, second s2r wakes up immediately
From: Thomas Meyer <thomas@m3y3r.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <alpine.LNX.2.00.0906161014550.7457@wotan.suse.de>
References: <1244996001.8440.10.camel@localhost>
	 <200906142031.38358.elendil@planet.nl> <1245006429.23043.2.camel@localhost>
	 <200906142129.08135.rjw@sisk.pl>
	 <alpine.LNX.2.00.0906142246120.7457@wotan.suse.de>
	 <1245083361.6821.1.camel@localhost>
	 <alpine.LNX.2.00.0906161014550.7457@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 19:13:51 +0200
Message-Id: <1245172431.6210.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 16.06.2009, 10:15 +0200 schrieb Jiri Kosina:
> On Mon, 15 Jun 2009, Thomas Meyer wrote:
> 
> > > > As for the mouse itself, I don't know.  I'm not even sure if it's 
> > > > possible at all (CCing Jiri).
> > > The main question is whether the mouse really is generating wakeup event 
> > > even if unused.
> > > Could you please provide usbmon dumps (Documentation/usb/usbmon.txt) from 
> > > the failing suspend session?
> > I tried and usbmon seems to kill my machine. See attached screenshot.
> 
> Unfortunately the trace is far from being complete -- most importantly, 
> the first lines of the oops/BUG are missing. Is there any chance you could 
> either set up a serial console, or choose a smaller console font, to catch 
> the whole thing?

Netconsole was able to catch this:

[ 8689.244202] BUG: unable to handle kernel paging request at ffff880020fb0e80
[ 8689.244235] IP: [<ffffffffa002d47f>] mon_dmapeek+0x68/0x8d [usbmon]
[ 8689.244265] PGD 202063 PUD 206063 PMD 20e001e2 
[ 8689.244293] Oops: 0000 [#1] PREEMPT SMP 
[ 8689.244318] last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
[ 8689.244329] CPU 0 

That's all.

Is this useful for you?

