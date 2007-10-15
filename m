Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbXJOU4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbXJOU4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbXJOU4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:56:18 -0400
Received: from main.gmane.org ([80.91.229.2]:36627 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbXJOU4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:56:17 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Killing a network connection
Date: Mon, 15 Oct 2007 14:40:59 -0400
Message-ID: <jwvodf01b5i.fsf-monnier+gmane.linux.kernel@gnu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: x-132-204-240-91.xtpr.umontreal.ca
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.50 (gnu/linux)
Cancel-Lock: sha1:N9WoZ4BQ8faLVPaumCRgBcejqK0=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ I suppose this is not the best place to ask this, but
  comp.os.linux.networking couldn't come up with a good answer and I can't
  think of any intermediate step between these two groups ;-( ]

I'd like (as root, obviously) to kill some of the TCP connections visible
in netstat.  I've found `tcpkill' and `cutter' but `cutter' only kills TCP
connections that go *though* the machine (in my case, the machine is not
a router, so there aren't any such thu connections anyway) and `tcpkill'
can only kill the conection after seeing some activity (and it doesn't know
to exit when the connections are killed).  Also those 2 tools seem
just overkill.
I'd like simply to do (metaphorically)

  rm /tcpfs/<foo>

so it should not need to involve *any* use of the TCP protocol: just kill it
locally, warn the associated process(es), free the resources and let the
other end deal with it.

The main use for me is to deal with dangling connections due to taking
network interfaces up&down with different IP addresses (typically the wlan0
interface where the IP is different because I've modes from an AP to
another).  Of course, maybe there's another way to solve this particular
problem, in case I'd like to hear about it as well.


        Stefan

