Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbYELVuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbYELVuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 17:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbYELVuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 17:50:04 -0400
Received: from mx1.suse.de ([195.135.220.2]:44819 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbYELVuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 17:50:01 -0400
Date: Mon, 12 May 2008 14:50:00 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Leonardo Potenza <lpotenza@inwind.it>
Cc: kernel-janitors@vger.kernel.org, joel.becker@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs/ocfs2/cluster: compilation warning fix
Message-ID: <20080512215000.GC25156@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <200805111908.06046.lpotenza@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805111908.06046.lpotenza@inwind.it>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
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

Ok, both of your patches look good for Ocfs2.git. Thanks.
	--Mark

--
Mark Fasheh
