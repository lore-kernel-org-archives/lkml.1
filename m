Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbYCZIIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbYCZIIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 04:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYCZIId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 04:08:33 -0400
Received: from smtp7-g19.free.fr ([212.27.42.64]:58782 "EHLO smtp7-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbYCZIIb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 04:08:31 -0400
Date: Wed, 26 Mar 2008 09:05:27 +0100
From: Emmanuel Florac <eflorac@intellique.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: RAID-1 performance under 2.4 and 2.6
Message-ID: <20080326090527.42286e8e@galadriel.home>
In-Reply-To: <47E98DE4.9000906@tmr.com>
References: <20080325194306.4ac71ff2@galadriel.home>
	<47E975F8.3000702@redhat.com>
	<47E98108.9000906@tmr.com>
	<47E98712.6090203@redhat.com>
	<47E98DE4.9000906@tmr.com>
Organization: Intellique
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tue, 25 Mar 2008 19:42:28 -0400 vous écriviez:

> And this is what I was saying earlier, there is a trend to blame the 
> benchmark when in fact the same benchmark runs well on 2.4. 

As I mentioned, it looks like 2.4 actually buffers write data on RAID-1
which is inherently bad (after all if I do RAID-1 it's for the sake of
data integrity, and write caching just counters that).
However, how bad dd may be, it reflects broadly my problem : on small
systems using software RAID, IO is overall way better with 2.4 than
2.6, especially NFS thruput.
Though I can substantially enhance 2.6 performance through tweaking
(playing with read ahead, disk queue length etc), it still lags behind
2.4 with defaults settings by a clear margin (10% or more).
This isn't true - fortunately - of larger systems with 12, 24, 48 disks
drives, hardware RAID, Fibre Channel and al. 

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
