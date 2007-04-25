Return-Path: <linux-kernel-owner+w=401wt.eu-S1422636AbXDYFmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422636AbXDYFmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 01:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbXDYFmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 01:42:09 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754583AbXDYFmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 01:42:06 -0400
Date: Tue, 24 Apr 2007 22:41:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: 2.6.21-rc7-mm1 + sysfs-oops-workaround.patch -- software
 suspend failed (1 tasks refusing to freeze)
Message-Id: <20070424224137.0ccf7874.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0704242227x14986fe3v5c2fc3a5bceedc89@mail.gmail.com>
References: <a44ae5cd0704242227x14986fe3v5c2fc3a5bceedc89@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 22:27:44 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:

> [ 1251.506964] PM: Preparing system for mem sleep
> [ 1251.514790] Stopping tasks ...
> [ 1271.456065] Stopping user space processes timed out after 20
> seconds (1 tasks refusing to freeze):
> [ 1271.456243]  multiload-apple
> [ 1271.456291] Restarting tasks ... done.
> 
> This isn't happening under earlier builds I've tested.  How can I debug this?
> 

hm, that's multiload-applet, some gnome thing.

sysrq-T, perhaps?  Perhaps the process is sleeping in the kernel somewhere.

