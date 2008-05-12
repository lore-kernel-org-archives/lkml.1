Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbYELVz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbYELVz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 17:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbYELVzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 17:55:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61106 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbYELVzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 17:55:11 -0400
Date: Mon, 12 May 2008 14:54:22 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Leonardo Potenza <lpotenza@inwind.it>
Cc: kernel-janitors@vger.kernel.org, mfasheh@suse.com,
       linux-kernel@vger.kernel.org, sunil.mushran@oracle.com
Subject: Re: [PATCH 1/2] fs/ocfs2/cluster: compilation warning fix
Message-ID: <20080512215422.GG12100@mail.oracle.com>
Mail-Followup-To: Leonardo Potenza <lpotenza@inwind.it>,
	kernel-janitors@vger.kernel.org, mfasheh@suse.com,
	linux-kernel@vger.kernel.org, sunil.mushran@oracle.com
References: <200805111908.06046.lpotenza@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805111908.06046.lpotenza@inwind.it>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 07:08:05PM +0200, Leonardo Potenza wrote:
> From: Leonardo Potenza <lpotenza@inwind.it>
> 
> Removed the warning messages:
> fs/ocfs2/cluster/tcp.h:132: warning: 'o2net_debugfs_init' defined but not used
> fs/ocfs2/cluster/tcp.h:136: warning: 'o2net_debugfs_exit' defined but not used
> fs/ocfs2/cluster/tcp.h:139: warning: 'o2net_debug_add_nst' defined but not used
> fs/ocfs2/cluster/tcp.h:142: warning: 'o2net_debug_del_nst' defined but not used
> fs/ocfs2/cluster/tcp.h:145: warning: 'o2net_debug_add_sc' defined but not used
> fs/ocfs2/cluster/tcp.h:148: warning: 'o2net_debug_del_sc' defined but not used
> 
> If not in debug build (CONFIG_DEBUG_FS), the definition of those functions
> has been moved from 'tcp.h' to 'netdebug.c'.

	They should stay in tcp.h but be static inline.  That's the
problem.

Joel

-- 

"Too much walking shoes worn thin.
 Too much trippin' and my soul's worn thin.
 Time to catch a ride it leaves today
 Her name is what it means.
 Too much walking shoes worn thin."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
