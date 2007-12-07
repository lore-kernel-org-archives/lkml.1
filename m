Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbXLGKQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbXLGKQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 05:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbXLGKQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 05:16:04 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55545 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041AbXLGKQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 05:16:03 -0500
Date: Fri, 7 Dec 2007 02:15:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc4-mm1 -- boot process hangs -- tty4 main process
 (2988) terminated with status 1
Message-Id: <20071207021556.ce08dfa6.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0712061956i1bd8f354rbfcffdbafad2e5d8@mail.gmail.com>
References: <a44ae5cd0712061956i1bd8f354rbfcffdbafad2e5d8@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007 22:56:53 -0500 "Miles Lane" <miles.lane@gmail.com> wrote:

> The machine is:  http://www.gateway.com/retail/mt6821.php
> Gnu C                  4.2.3
> Gnu make               3.81
> binutils               2.18.20071027
> util-linux             2.13.1-rc1
> mount                  2.13.1-rc1
> module-init-tools      3.3-pre11
> e2fsprogs              1.40.2
> reiserfsprogs          3.6.19
> pcmciautils            014
> PPP                    2.4.4
> Linux C Library        2.6.1
> Dynamic linker (ldd)   2.6.1
> Procps                 3.2.7
> Net-tools              1.60
> Console-tools          0.2.3
> Sh-utils               5.97
> udev                   113
> wireless-tools         29
> 
> Dec  6 21:24:09 erratic-orbits kernel: Inspecting
> /boot/System.map-2.6.24-rc4-mm1
> Dec  6 21:24:09 erratic-orbits kernel: Loaded 32575 symbols from
> /boot/System.map-2.6.24-rc4-mm1.
> Dec  6 21:24:09 erratic-orbits kernel: Symbols match kernel version 2.6.24.
> Dec  6 21:24:09 erratic-orbits kernel: Loaded 2594 symbols from 18 modules.
> Dec  6 21:24:09 erratic-orbits kernel: Initializing cgroup subsys cpuset
> Dec  6 21:24:09 erratic-orbits kernel: Linux version 2.6.24-rc4-mm1
> (root@erratic-orbits) (gcc version 4.2.3 20071123 (prerelease) (Ubuntu
>
> ...
>
> Dec  6 21:24:28 erratic-orbits init: tty5 main process ended, respawning
> Dec  6 21:24:28 erratic-orbits init: tty2 main process (2990)
> terminated with status 1
> Dec  6 21:24:28 erratic-orbits init: tty2 main process ended, respawning
> Dec  6 21:24:28 erratic-orbits init: tty3 main process (2991)
> terminated with status 1

Boggle.  We broke the vt driver?

config, please...
