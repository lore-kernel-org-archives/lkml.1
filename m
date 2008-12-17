Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759497AbYLQKtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbYLQKtB (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 05:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbYLQKst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 05:48:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49322 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbYLQKss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 05:48:48 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jiri Pirko <jpirko@redhat.com>
Subject: Re: [PATCH, RESEND2] getrusage: fill ru_maxrss value
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Michael Kerrisk" <mtk.manpages@googlemail.com>,
        linux-api@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
        jlim@sgi.com
In-Reply-To: <20081217105639.63e765eb@psychotron.englab.brq.redhat.com>
References: <20081217105639.63e765eb@psychotron.englab.brq.redhat.com>
Message-Id: <20081217194646.F677.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 17 Dec 2008 19:48:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (updated)
> 
> This patch makes ->ru_maxrss value in struct rusage filled accordingly to
> rss hiwater mark. This struct is filled as a parameter to
> getrusage syscall. ->ru_maxrss value is set to pages which might be correct
> as "time" application converts it to KBs.

Why?
if kernel convert to KB, glibc don't need any change.



