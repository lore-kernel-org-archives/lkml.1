Return-Path: <linux-kernel-owner+w=401wt.eu-S1760477AbYBRNAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760477AbYBRNAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760206AbYBRNA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:00:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53830 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760185AbYBRNAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:00:25 -0500
Date: Mon, 18 Feb 2008 04:59:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@ckeith.clara.net
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: Oops on 2.6.24.2 "rmmod fan" && "rmmod 8250_pnp"
Message-Id: <20080218045904.1c5aacac.akpm@linux-foundation.org>
In-Reply-To: <20080215003419.GE15194@dot.oreally.co.uk>
References: <20080215003419.GE15194@dot.oreally.co.uk>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 00:34:19 +0000 linux-kernel@ckeith.clara.net wrote:

> Hi,
> 
> Just trying out 2.6.24.2 and in unloading some modules which I don't need
> managed to generate kernel oopsii. My apologies if these had been reported,
> I did a search and didn't see any other reports.
> 
> rmmod fan gives:
> 
> Feb 14 19:02:22 nike kernel: [  150.012343] WARNING: at fs/proc/generic.c:736 remove_proc_entry()
> Feb 14 19:02:22 nike kernel: [  150.012379] Pid: 3570, comm: rmmod Not tainted 2.6.24.2 #1
> Feb 14 19:02:22 nike kernel: [  150.012465]
> Feb 14 19:02:22 nike kernel: [  150.012466] Call Trace:
> Feb 14 19:02:22 nike kernel: [  150.012536]  [<ffffffff802ea0db>] remove_proc_entry+0x198/0x1df
> Feb 14 19:02:22 nike kernel: [  150.012587]  [<ffffffff8032a8de>] kobject_release+0x0/0xf
> Feb 14 19:02:22 nike kernel: [  150.012619]  [<ffffffff8032a8eb>] kobject_release+0xd/0xf
> Feb 14 19:02:22 nike kernel: [  150.012650]  [<ffffffff8032b906>] kref_put+0x5f/0x6b
> Feb 14 19:02:22 nike kernel: [  150.012682]  [<ffffffff8032a844>] kobject_put+0x19/0x1b
> Feb 14 19:02:22 nike kernel: [  150.012714]  [<ffffffff803988aa>] bus_put+0xd/0xf
> Feb 14 19:02:22 nike kernel: [  150.012746]  [<ffffffff80398966>] bus_remove_driver+0xba/0xc3
> Feb 14 19:02:22 nike kernel: [  150.012783]  [<ffffffff881e3367>] :fan:acpi_fan_exit+0x23/0x25
> Feb 14 19:02:22 nike kernel: [  150.012815]  [<ffffffff80264c1d>] sys_delete_module+0x1b0/0x1e3
> Feb 14 19:02:22 nike kernel: [  150.012851]  [<ffffffff8020f707>] syscall_trace_enter+0xb7/0xbb
> Feb 14 19:02:22 nike kernel: [  150.012885]  [<ffffffff8020c21a>] tracesys+0xdc/0xe1
> Feb 14 19:02:22 nike kernel: [  150.012920]

Alexey touched it last!  Might be acpi doing something bad.


