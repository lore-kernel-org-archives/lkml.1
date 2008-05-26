Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbYEZLRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbYEZLRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 07:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYEZLRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 07:17:34 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45834 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYEZLRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 07:17:33 -0400
Date: Mon, 26 May 2008 13:17:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Guy Watkins <linux-raid@watkins-home.com>
cc: "'David Lethe'" <david@santools.com>,
       "'LinuxRaid'" <linux-raid@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: RE: Mechanism to safely force repair of single md stripe w/o hurting
 data integrity of file system
In-Reply-To: <200805172026.m4HKQwh06910@www.watkins-home.com>
Message-ID: <alpine.LNX.1.10.0805261316400.19084@fbirervta.pbzchgretzou.qr>
References: <200805172026.m4HKQwh06910@www.watkins-home.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-05-17 22:26, Guy Watkins wrote:
>
>I thought this would cause md to read all blocks in an array:
>echo repair > /sys/block/md0/md/sync_action
>
>And rewrite any blocks that can't be read.
>
>In the old days, md would kick out a disk on a read error.  When you added
>it back, md would rewrite everything on that disk, which corrected read
>errors.

With a read bitmap (`mdadm -G /dev/mdX -b internal`, or during -C),
it should resync less after an unwarranted kick.
