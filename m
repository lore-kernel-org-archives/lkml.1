Return-Path: <linux-kernel-owner+w=401wt.eu-S1760616AbZKZPBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616AbZKZPBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 10:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760270AbZKZPBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 10:01:04 -0500
Received: from borg.medozas.de ([188.40.89.202]:36680 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbZKZPBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 10:01:03 -0500
Date: Thu, 26 Nov 2009 16:01:08 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Programs die when max_map_count is too large
Message-ID: <alpine.LSU.2.00.0911261600070.7313@obet.zrqbmnf.qr>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


setting max_map_count to a value large enough results in programs dying 
at first try.
This is on 2.6.31.6.

15:59 borg:/proc/sys/vm # echo $[1<<31-1] >max_map_count 
15:59 borg:/proc/sys/vm # cat max_map_count
1073741824
15:59 borg:/proc/sys/vm # echo $[1<<31] >max_map_count 
15:59 borg:/proc/sys/vm # cat max_map_count
Killed


thanks,
Jan
