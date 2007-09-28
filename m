Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbXI1Qa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbXI1Qa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 12:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbXI1QaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 12:30:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:53232 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbXI1QaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:30:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JvZiYco5HUMoFznhc7fVV+riJrcEME11su9xTR7Tp9kyDjyD4zBgrA/wJttuIjI46N5tYDIYWrjvJxuATos4B3ziLAsxYog0+dpwryayQdNAC+DRyPQOhsQvYjoBWne262rwQQv3xqpAuVb/eiGW7TaLDtXAwL0+pX1h53lre7o=
Message-ID: <46FD2C10.8050105@gmail.com>
Date: Fri, 28 Sep 2007 18:30:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Eric Biederman <ebiederm@xmission.com>
Subject: /proc/net/ bad hard links count [Was: 2.6.23-rc8-mm2]
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
In-Reply-To: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2007 11:22 AM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/

# find /proc >/dev/null
find: WARNING: Hard link count is wrong for /proc/net: this may be a bug in your
filesystem driver.  Automatically turning on find's -noleaf option.  Earlier
results may have failed to include directories that should have been searched.
# stat net
  File: `net'
  Size: 0               Blocks: 0          IO Block: 1024   directory
Device: 3h/3d   Inode: 4026531864  Links: 2
Access: (0555/dr-xr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2007-09-28 18:21:24.651209759 +0200
Modify: 2007-09-28 18:21:24.651209759 +0200
Change: 2007-09-28 18:21:24.651209759 +0200
# stat net/
  File: `net/'
  Size: 0               Blocks: 0          IO Block: 1024   directory
Device: 3h/3d   Inode: 4026531909  Links: 4
Access: (0555/dr-xr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2007-09-28 18:26:48.813048220 +0200
Modify: 2007-09-28 18:26:48.813048220 +0200
Change: 2007-09-28 18:26:48.813048220 +0200

hmm, this is some kind of weirdness :)

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
