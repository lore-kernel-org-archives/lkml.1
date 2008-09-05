Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbYIEEpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbYIEEpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 00:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbYIEEpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 00:45:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbYIEEpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 00:45:09 -0400
Date: Thu, 4 Sep 2008 21:44:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: Tree for September 4
Message-Id: <20080904214437.c53f02d9.akpm@linux-foundation.org>
In-Reply-To: <20080904193606.573f2cb3.sfr@canb.auug.org.au>
References: <20080904193606.573f2cb3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 19:36:06 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

The infamous Vaio hasn't finished catching up with you guys yet. 
Something in linux-next broke suspend-to-RAM.

An `echo mem > /sys/power/state' causes "Freezing of tasks failed after
20.00 seconds (1 tasks refusing to freeze):"

dmesg: http://userweb.kernel.org/~akpm/dmesg-sony-suspend.txt
config: http://userweb.kernel.org/~akpm/config-sony.txt

This only happens after the X server has been started.

Mainline is OK.
