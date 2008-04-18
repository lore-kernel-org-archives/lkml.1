Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbYDRHyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbYDRHyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 03:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYDRHyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 03:54:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622AbYDRHyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 03:54:10 -0400
Date: Fri, 18 Apr 2008 00:53:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-pm@lists.linux-foundation.org, linux-usb@vger.kernel.org,
       Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.25-mm1: not looking good
Message-Id: <20080418005323.7c015c42.akpm@linux-foundation.org>
In-Reply-To: <20080418005034.6e4dd9e7.akpm@linux-foundation.org>
References: <20080417160331.b4729f0c.akpm@linux-foundation.org>
	<20080418005034.6e4dd9e7.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 00:50:34 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> dmesg: http://userweb.kernel.org/~akpm/x.txt
> config: http://userweb.kernel.org/~akpm/config-t61p.txt

oop, there's more:


sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
firewire_core: created device fw0: GUID 00016c2000174bad, S400
PM: Device usb4 failed to restore: error -113
eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
eth0: 10/100 speed: disabling TSO
PM: Device usb5 failed to restore: error -113
PM: Device usb7 failed to restore: error -113
sd 0:0:0:0: [sda] Starting disk
PM: Image restored successfully.
Restarting tasks ... done.
PM: Basic memory bitmaps freed

Those USB restore failures are new.  They're similar to the ones on the
doesnt-resume-properly-any-more Vaio.  They came out from the machine's
second (successful) resume-from-disk.
