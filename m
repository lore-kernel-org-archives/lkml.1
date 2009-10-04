Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbZJDUGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbZJDUGY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 16:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbZJDUGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 16:06:23 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:50694 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733AbZJDUGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 16:06:23 -0400
Message-ID: <4AC90019.6030406@pardus.org.tr>
Date: Sun, 04 Oct 2009 23:05:45 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Pekka Paalanen <pq@iki.fi>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       jens.axboe@oracle.com, dri-devel@lists.sf.net
Subject: Re: NULL pointer dereference at cfq_exit_single_io_context
References: <4AC85907.7080805@pardus.org.tr> <20091004193111.1e8e3baf@daedalus.pq.iki.fi>
In-Reply-To: <20091004193111.1e8e3baf@daedalus.pq.iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Paalanen wrote:
> This problem should be fixed now, we debugged it for a long time. E.g.
> https://bugs.freedesktop.org/show_bug.cgi?id=23847
>
> The commit:
> http://cgit.freedesktop.org/nouveau/linux-2.6/commit/?id=7798546495c04a810db86be34ba1f39e370fd325
> "drm/nouveau: fix missized allocation for ttm_bo_global struct"
>
> I hope that solves your issue.
>   

Oh that's a nice clue. I will try with the patched kernel, thanks a lot!

Regards,

