Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYGaQEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYGaQEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYGaQEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:04:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60466 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbYGaQEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:04:44 -0400
Date: Thu, 31 Jul 2008 17:04:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: zhangxiliang <zhangxiliang@cn.fujitsu.com>, sgrubb@redhat.com,
       Linux Audit <linux-audit@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix the bug of using AUDIT_STATUS_RATE_LIMIT when set
	fail, no error output.
Message-ID: <20080731160438.GK28946@ZenIV.linux.org.uk>
References: <48911F47.50606@cn.fujitsu.com> <1217474150.2902.76.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217474150.2902.76.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 11:15:50PM -0400, Eric Paris wrote:
> On Thu, 2008-07-31 at 10:11 +0800, zhangxiliang wrote:
> > When the "status_get->mask" is "AUDIT_STATUS_RATE_LIMIT || AUDIT_STATUS_BACKLOG_LIMIT".
> > If "audit_set_rate_limit" fails and "audit_set_backlog_limit" succeeds, the "err" value will be greater than or equal to 0. It will miss the failure of rate set. 
> > 
> > Signed-off-by: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
> 
> man, it gives me the heebee jeebies with the coding style but it follows
> everything else

Sanitized, applied, pushed to audit-current (audit.b53)
