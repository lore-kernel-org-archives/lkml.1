Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbXDZV34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbXDZV34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbXDZV34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:29:56 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752449AbXDZV3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:29:51 -0400
Date: Thu, 26 Apr 2007 14:28:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Vladimir Lebedev <vladimir.p.lebedev@intel.com>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.21-rc7-mm2 -- gnome-power-manager always shows the power as
 coming from AC
Message-Id: <20070426142824.9da91feb.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0704261213o37944b46u5dbdd231fc6a2490@mail.gmail.com>
References: <a44ae5cd0704261213o37944b46u5dbdd231fc6a2490@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 12:13:00 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:

> One possible issue is that /proc/acpi/power_resource/ is an empty directory.
> Otherwise, the ACPI information seems to be fine:
> 
> # cat /proc/acpi/ac_adapter/ACAD/state
> state:                   on-line
> # cat /proc/acpi/ac_adapter/ACAD/state
> state:                   off-line
> 
> # cat /proc/acpi/battery/BAT0/state
> present:                 yes
> capacity state:          ok
> charging state:          discharging
> present rate:            0 mA
> remaining capacity:      7072 mAh
> present voltage:         12487 mV
> 
> When I unplug the power cable, /proc/acpi/battery/BAT0/state (present
> rate) shows that current flowing from the battery.
> 
> # cat /proc/acpi/button/lid/LID0/state
> state:      closed
> # cat /proc/acpi/button/lid/LID0/state
> state:      open

hm, I'm looking suspiciously at "ACPI: Cache battery status instead of
re-evaluating AML".

What sort of machine is this?
