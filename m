Return-Path: <linux-kernel-owner+w=401wt.eu-S933872AbZLOXVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872AbZLOXVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932974AbZLOXVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:21:51 -0500
Received: from smtp107.biz.mail.mud.yahoo.com ([68.142.200.255]:45570 "HELO
	smtp107.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761720AbZLOXBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:01:11 -0500
X-Yahoo-SMTP: qGLgp.mswBDSnFfWmYVMF5Rmg6NJ
X-YMail-OSG: mMrfqvgVM1lYAYKrYkKer2C5JsY3p8vgn6.4oVoGR_oPekKKzk5vPf4e_bMuSjPS0yMYcgn8VGzWFW6irYhUfL743632DzA6ao16tqrV6enoOAJOPFL_701xynSYHfkfFz5Oa6d.f6fQFpVL02u60vg.IvHu0Qv7Lvjdi9bxMn3CTKUuJTR7ithE4TIeROIdNo4g6yiZufXsv6H.RN_N065hFCtSLr9a3O7zN1WLgj.sGOmNjrt0Nyqa8vUllqpsnEqOSge43pbnG8.rMXipHvdJJ2MwokWDpscEEEJhd0Ww6XksvLVOuh8HkdG5PHhN0VA5Kj3bsNfAlPSpYIm0MgLGuyS9UF3Lpg9MDEsNEC8Bl0GVPg1kdsTGY9vq3nLe5A--
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: [current HEAD] commit 5ad6468801d28c4d4ac9f48ec19297817c915f6a breaks the build on m68knommu
Date: Tue, 15 Dec 2009 15:01:04 -0800
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912151501.05552.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and I suspect on any nommu:

In file included from kernel/fork.c:52:
include/linux/ksm.h:129: warning: 'enum ttu_flags' declared inside parameter 
list
include/linux/ksm.h:129: warning: its scope is only this definition or 
declaration, which is probably not what you want
include/linux/ksm.h:129: error: parameter 2 ('flags') has incomplete type
make[1]: *** [kernel/fork.o] Error 1
make[1]: *** Waiting for unfinished jobs....

-- 
Steven King -- sfking at fdwdc dot com
