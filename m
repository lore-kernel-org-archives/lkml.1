Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbXI3U3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbXI3U3A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 16:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXI3U2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 16:28:52 -0400
Received: from lazybastard.de ([212.112.238.170]:41775 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbXI3U2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 16:28:51 -0400
Date: Sun, 30 Sep 2007 22:24:29 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Artem Bityutskiy <dedekind@yandex.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Write-back from inside FS - need suggestions
Message-ID: <20070930202429.GA30514@lazybastard.org>
References: <46FCC686.3050009@yandex.ru> <46FE2167.8000800@yandex.ru> <20070929033939.6ee65e19.akpm@linux-foundation.org> <46FEA332.9090904@yandex.ru> <20070929130011.c3a11139.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070929130011.c3a11139.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 September 2007 13:00:11 -0700, Andrew Morton wrote:
> 
> err, it's basically an open-coded mutex via which one thread can get
> exclusive access to some parts of an inode's internals.  Perhaps it could
> literally be replaced with a mutex.  Exactly what I_LOCK protects has not
> been documented afaik.  That would need to be reverse engineered :(

I believe you actually have some documentation in your tree.  At least
the behaviour after my I_SYNC patch has been documented with that patch.

Jörn

-- 
"Error protection by error detection and correction."
-- from a university class
