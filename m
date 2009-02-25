Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbZBYO3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbZBYO3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbZBYO24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:28:56 -0500
Received: from frankvm.xs4all.nl ([80.126.170.174]:60113 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754696AbZBYO24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:28:56 -0500
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Feb 2009 09:28:56 EST
Date: Wed, 25 Feb 2009 15:21:36 +0100
From: Frank van Maarseveen <frankvm@frankvm.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.27.14: BUG: lock held when returning to user space!
Message-ID: <20090225142136.GA29505@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An lvextend -L+16G command for a logical volume while being mounted rw
as ext3 triggered the following on 2.6.27.14:

================================================
[ BUG: lock held when returning to user space! ]
------------------------------------------------
lvextend/29191 is leaving the kernel with locks still held!
2 locks held by lvextend/29191:
 #0: (&type->s_umount_key #15){....}, at: [<c019edfb>] get_super+0x6b/0xb0
 #1: (&journal->j_barrier){....}, at: [<c01f9af3>] journal_lock_updates+0xc3/0xd0

-- 
Frank
