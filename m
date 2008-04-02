Return-Path: <linux-kernel-owner+w=401wt.eu-S1761159AbYDBTAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761159AbYDBTAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758869AbYDBS7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:59:54 -0400
Received: from gw.goop.org ([64.81.55.164]:50117 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759317AbYDBS7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:59:53 -0400
Message-ID: <47F3D76E.1070400@goop.org>
Date: Wed, 02 Apr 2008 11:58:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: xfs_io "BUG: lock held when returning to user space!" on suspend
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting this:

================================================
[ BUG: lock held when returning to user space! ]
------------------------------------------------
xfs_io/18796 is leaving the kernel with locks still held!
1 lock held by xfs_io/18796:
 #0:  (&type->s_umount_key#19){----}, at: [<c048c9ac>] get_super+0x42/0x87

when I suspend, possibly during an xfs-freeze.  There don't seem to be any ill-effects.

Thanks,
	J

