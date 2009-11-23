Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZKWO7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZKWO7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZKWO7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:59:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbZKWO7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:59:18 -0500
Subject: Re: kvmmmu tracing
From: Steven Rostedt <srostedt@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1258974375.7094.158.camel@johannes.local>
References: <1258974375.7094.158.camel@johannes.local>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 23 Nov 2009 09:58:58 -0500
Message-Id: <1258988338.31359.147.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 12:06 +0100, Johannes Berg wrote:
> Commit f691fe1da7e2715137d21ae5a80bec64db4625db is really broken wrt.
> the userspace interface for tracing because of the weird
> KVM_MMU_PAGE_PRINTK macro.
> 
> Maybe we should have a "unsafe for export" flag for events, if they do
> strange things like that?
> 
> As it stands, I can't use trace-cmd on an x86 machine that has kvm
> enabled because it will try to read all the kvm stuff. Arguably, it
> should only try to parse it when it needs it (i.e. not for me) but still
> it's very inconvenient to export something to userspace that it cannot
> possibly understand.

Note, I updated trace-cmd. I still does not read this macro nicely, but
it at least does not fail anymore.

-- Steve


