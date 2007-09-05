Return-Path: <linux-kernel-owner+w=401wt.eu-S932415AbXIEXaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbXIEXaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 19:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbXIEXaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 19:30:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbXIEXaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 19:30:09 -0400
Message-ID: <46DF3BFF.9000809@redhat.com>
Date: Wed, 05 Sep 2007 19:30:07 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Why do so many machines need "noapic"?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some systems lock up without the noapic option. I found one
that will freeze while trying to set up the timer interrupt.
Passing 'nolapic' makes it freeze just after:

   Setting up timer through ExtINT... works

Sometimes it will boot up and then freeze during the startup
scripts. Passing the noapic option fixes all that, but it
then gets 1000 spurious interrupts per second on IRQ7 (which
only shows ehci using it.) Kernel version is 2.6.22.
