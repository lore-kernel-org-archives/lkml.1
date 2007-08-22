Return-Path: <linux-kernel-owner+w=401wt.eu-S1761499AbXHVKLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761499AbXHVKLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759891AbXHVKLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:11:32 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:7174 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759433AbXHVKLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:11:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=mgnu6+HnMqJog3PIN8arTe2A8A3W7MoK+zpzo+0vanMzGkoIHqaEIZuOS/NtBAhIxlsD8rwnvUTZ1AwZchsIDsAi3+fZ4phup8XSn3yHcE4QeCpem41USC8Eb8du+SzlULDKbGX/lXgEnevadZAP1LzaG+jUUMjhv5iUkeo2qvQ=
Message-ID: <46CC0BC2.7060400@googlemail.com>
Date: Wed, 22 Aug 2007 12:11:14 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com
Subject: [BUG] fs/xfs/xfs_bmap_btree.c:2312: error: 'b' undeclared (first
 use in this function) (Was Re: 2.6.23-rc3-mm1)
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton pisze:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> 

/home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c: In function 'xfs_bmbt_set_allf':
/home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c:2312: error: 'b' undeclared (first use in this function)
/home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c:2312: error: (Each undeclared identifier is reported only once
/home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c:2312: error: for each function it appears in.)
/home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c: In function 'xfs_bmbt_disk_set_allf':
/home/devel/linux-mm/fs/xfs/xfs_bmap_btree.c:2372: error: 'b' undeclared (first use in this function)
make[3]: *** [fs/xfs/xfs_bmap_btree.o] Error 1
make[2]: *** [fs/xfs] Error 2
make[1]: *** [fs] Error 2
make: *** [_all] Error 2

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/

