Return-Path: <linux-kernel-owner+w=401wt.eu-S1764444AbXLTXFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764444AbXLTXFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbXLTXFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:05:43 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50146 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762168AbXLTXFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:05:42 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Jan Beulich" <jbeulich@novell.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] constify tables in kernel/sysctl_check.c
References: <476A73A3.76E4.0078.0@novell.com>
Date: Thu, 20 Dec 2007 16:05:28 -0700
In-Reply-To: <476A73A3.76E4.0078.0@novell.com> (Jan Beulich's message of "Thu,
	20 Dec 2007 12:52:35 +0000")
Message-ID: <m1y7bp6k7b.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jan Beulich" <jbeulich@novell.com> writes:

> Remains the question whether it is intended that many, perhaps even
> large, tables are compiled in without ever having a chance to get used,
> i.e. whether there shouldn't #ifdef CONFIG_xxx get added.


The constification looks good.  The file should be compiled only when
we have sysctl support.  We use those tables when we call 
register_sysctl_table.  Which we do a lot.

Eric
