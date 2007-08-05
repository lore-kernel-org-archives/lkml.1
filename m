Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbXHEPfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbXHEPfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 11:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759480AbXHEPfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 11:35:33 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56513 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759368AbXHEPfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 11:35:32 -0400
Date: Sun, 5 Aug 2007 17:35:31 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: =?iso-8859-1?Q?J=F6rg_Hoffmann?= <jh2000@root24.eu>
cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch] panic.c
In-Reply-To: <006701c7d775$53137cc0$6800a8c0@jhnotebook>
Message-ID: <Pine.LNX.4.64.0708051731050.29913@fbirervta.pbzchgretzou.qr>
References: <006701c7d775$53137cc0$6800a8c0@jhnotebook>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-1887113740-1186328131=:29913"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-1887113740-1186328131=:29913
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Aug 5 2007 17:28, Jörg Hoffmann wrote:
>Hello everybody,
>(This is the first time i send in a patch, so correct me if Im doing
>something wrong)

See Documentation/SubmittingPatches. (And perhaps, U+0092 should be replaced by
something visible ;-)

>This patch causes the cpu to stop instead of using an endless loop (Im
>not sure if this works with the watchdog so please take a review).
>The idea behind this is to keep the power usage on panicd machines
>(without auto-reboot) low. Another point is in an Virtual Machine
>environment the process of the VM is using 100% of the host-cpu. This
>would stuck other programs or VMs. This patch brings the VM to stop and
>keeps the cpu usage below 1%.
> 
>I have tested the patch in an VM, the only change is mdelay(); to
>cpu_idle(); it doesnt need more libs and should have no special
>depencies to consider.

cpu_idle() uses quite a lot of variables which may be invalid after a panic.

Something similar has been mentioned previously,
http://lkml.org/lkml/2006/6/19/303

>The panic-blink doesnt work further so it might be removed if there is
>no better way.
> 
>Maybe someone has an better idea for this problem
> 

	Jan
-- 
---699020219-1887113740-1186328131=:29913--
