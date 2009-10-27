Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbZJ0TCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbZJ0TCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbZJ0TCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:02:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52055 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbZJ0TCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:02:07 -0400
Date: Tue, 27 Oct 2009 12:01:21 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.32-rc not booting with Xen-3.2 (bisected)
In-Reply-To: <4AE73973.3070709@goop.org>
Message-ID: <alpine.DEB.2.01.0910271158100.9408@bogon.housecafe.de>
References: <alpine.DEB.2.01.0910261445170.9408@bogon.housecafe.de> <alpine.DEB.2.01.0910261513520.9408@bogon.housecafe.de> <4AE628DB.5010305@goop.org> <alpine.DEB.2.01.0910261759470.9408@bogon.housecafe.de> <alpine.DEB.2.01.0910261820050.9408@bogon.housecafe.de>
 <4AE67506.2040200@goop.org> <alpine.DEB.2.01.0910262154410.9408@bogon.housecafe.de> <4AE73973.3070709@goop.org>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX183yA/hwMl+VrigjaEASOPq7FA4VRtqz+rGBRm
 VIKBtHgUlDANhMzDniO0Lli/auGcsK+JY/CZ2+jJo3Qxjp5goy
 mbinlfHRnJjWZziFLLxEA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 at 11:18, Jeremy Fitzhardinge wrote:
> $ gdb vmlinux
> (gdb) x/i 0xffffffff812c50ad

The value is always ffffffff812c50ad, gdb says:

(gdb) x/i 0xffffffff812c50ad
0xffffffff812c50ad <xen_load_gdt_boot+252>:     ud2a  

> Hm, sounds like a xenstored bug, or something is just pounding on it. 
> Are there any other domains running, or other busy processes?

Yes, there's another domU running. But the high load and xenstored 
spinning is only happening when I try to start the domain with this 
2.6.32-rc kernel.

Christian.
-- 
BOFH excuse #145:

Flat tire on station wagon with tapes.  ("Never underestimate the bandwidth of a station wagon full of tapes hurling down the highway" Andrew S. Tannenbaum)
