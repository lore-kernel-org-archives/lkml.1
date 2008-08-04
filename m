Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYHDKUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYHDKUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbYHDKUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:20:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46181 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbYHDKUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:20:33 -0400
Date: Mon, 4 Aug 2008 11:20:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: zhangxiliang <zhangxiliang@cn.fujitsu.com>
Cc: Eric Paris <eparis@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
       Linux Audit <linux-audit@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yu Zhiguo <yuzg@cn.fujitsu.com>
Subject: Re: [PATCH] Fix the kernel panic of audit_filter_task when key
	field is set
Message-ID: <20080804102026.GW28946@ZenIV.linux.org.uk>
References: <4892F063.1080109@cn.fujitsu.com> <4893C42A.60803@cn.fujitsu.com> <4893CBA9.9020008@cn.fujitsu.com> <4893CCE5.7020907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4893CCE5.7020907@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2008 at 10:56:37AM +0800, zhangxiliang wrote:
> Sorry, I miss a blank between if and "(". 
> And I add "unlikely" to check "ctx" in audit_match_perm() and audit_match_filetype().
> This is a new patch for it.

Thanks.  Applied and pushed.
