Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZKMIjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZKMIjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbZKMIja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:39:30 -0500
Received: from smtp.nokia.com ([192.100.105.134]:40850 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbZKMIja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:39:30 -0500
Subject: Re: [PATCH] jffs2: Fix error return in
 jffs2_do_read_inode_internal()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AFC415C.6040305@gmail.com>
References: <4AFC415C.6040305@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 10:39:14 +0200
Message-Id: <1258101554.21596.1192.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Nov 2009 08:39:18.0799 (UTC) FILETIME=[CA47A9F0:01CA643C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 18:09 +0100, Roel Kluin wrote:
> The returned error should stay negative
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  fs/jffs2/readinode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Taken to my l2-mtd-2.6 tree, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

