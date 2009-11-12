Return-Path: <linux-kernel-owner+w=401wt.eu-S1759747AbZKLAWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbZKLAWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 19:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759591AbZKLAWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 19:22:08 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35103 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758940AbZKLAWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 19:22:07 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AFB5529.2010302@s5r6.in-berlin.de>
Date: Thu, 12 Nov 2009 01:22:01 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: ext3 build failure: "log_start_commit" [fs/ext3/ext3.ko] undefined
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

I just pulled linux-2.6.git and got this:
ERROR: "log_start_commit" [fs/ext3/ext3.ko] undefined!

I guess it is due to "ext3: Wait for proper transaction commit on fsync".

Is this log_start_commit() of fs/jbd/journal.c?

$ grep -e JBD -e EXT3 .config
CONFIG_EXT3_FS=m
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_JBD=m
CONFIG_JBD2=m

Hth,
-- 
Stefan Richter
-=====-==--= =-== -==--
http://arcgraph.de/sr/
