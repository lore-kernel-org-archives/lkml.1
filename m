Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbYGaWBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbYGaWBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbYGaWAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:00:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755476AbYGaWAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:00:50 -0400
Date: Thu, 31 Jul 2008 14:59:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: eparis@redhat.com, zhangxiliang@cn.fujitsu.com, sgrubb@redhat.com,
       linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the bug of using AUDIT_STATUS_RATE_LIMIT when set
 fail, no error output.
Message-Id: <20080731145934.cc3893de.akpm@linux-foundation.org>
In-Reply-To: <20080731160438.GK28946@ZenIV.linux.org.uk>
References: <48911F47.50606@cn.fujitsu.com>
	<1217474150.2902.76.camel@localhost.localdomain>
	<20080731160438.GK28946@ZenIV.linux.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 17:04:38 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Wed, Jul 30, 2008 at 11:15:50PM -0400, Eric Paris wrote:
> > On Thu, 2008-07-31 at 10:11 +0800, zhangxiliang wrote:
> > > When the "status_get->mask" is "AUDIT_STATUS_RATE_LIMIT || AUDIT_STATUS_BACKLOG_LIMIT".
> > > If "audit_set_rate_limit" fails and "audit_set_backlog_limit" succeeds, the "err" value will be greater than or equal to 0. It will miss the failure of rate set. 
> > > 
> > > Signed-off-by: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
> > 
> > man, it gives me the heebee jeebies with the coding style but it follows
> > everything else
> 
> Sanitized, applied, pushed to audit-current (audit.b53)

That tree doesn't appear to be in the linux-next lineup.  Fixable, please?
