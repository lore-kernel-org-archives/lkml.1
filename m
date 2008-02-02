Return-Path: <linux-kernel-owner+w=401wt.eu-S1761553AbYBBNMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761553AbYBBNMt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 08:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbYBBNMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 08:12:42 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:61960 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbYBBNMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 08:12:42 -0500
Date: Sat, 02 Feb 2008 14:12:40 +0100
Message-Id: <141150637@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: dhecht@vmware.com, tglx@linutronix.de
Subject: Re: Linux VM completely lost it`s timesource !?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX191Aux8lDqDWFNF0cd4uTBoWfUAuqwgPZaTYFICkkpFTLvTy
 Jo9rGsRf+7tnYbHB6shsdktNhB7NkxxY+78gP+Fj6B7QiiXt9c=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cat /sys/devices/system/clocksource/clocksource0/current_clocksource
acpi_pm

cannot switch to any other clocksource, "echo tsc|jiffies|pit >current_clocksource" doesn`t have any effect. 
current_clocksource stays at acpi_pm

maybe somebody has a clue what to check besides this?

thanks
roland


>I`m running 2.6.24 kernel in a recent version of vmware workstation and i`m unsure if \
>i hit a linux issue or a vmware issue here.
>
>after suspend/resume (hibernate) of my physical system (win xp), the linux guest \
>seems to have lost it´s timesource.
>
>don`t know much about timers in linux, so let me explain first:
>
>the guest was running when i suspended the xp host.
>the xp host is running fine after resume.
>the guest has issues.
>
>triggering a console beep inside the linux VM now doesn`t give a short beep but \
>terrorizing me with a never-ending continuous beep.
>
>seems to be a timer issue inside the guest, since tools like top, vmstat, watch etc \
>don`t work anymore. the system clock gone crazy, too - it`s counting from 22:40:47 to \
>22:40:51 and then constantly jumps back to 22:40:47
>
>can someone give an advice what to check to make sure that this is NOT a linux issue \
>? i will contact vmware then afterwards.
>
>regards
>roland
>
>ps:
>i did a snapshot of the VM and could preserve the state of the system this way.
________________________________________________________
Bis 50 MB Dateianhänge? Kein Problem!
http://www.digitaledienste.web.de/freemail/club/lp/?lp=7

