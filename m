Return-Path: <linux-kernel-owner+w=401wt.eu-S1765951AbZAQWWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765951AbZAQWWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 17:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbZAQWWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 17:22:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47517 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbZAQWWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 17:22:05 -0500
Date: Sat, 17 Jan 2009 23:19:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7][v7] proc: Show SIG_DFL signals to init as
	"ignored" signals
Message-ID: <20090117221909.GB3962@redhat.com>
References: <20090117202638.GA11825@us.ibm.com> <20090117203753.GH11825@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117203753.GH11825@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17, Sukadev Bhattiprolu wrote:
>
> Init processes ignore SIG_DFL signals unless they are from an ancestor
> namespace.  Ensure /proc/pid/status correcly reports these signals.

This is the user-visible change, and I don't really understand why do we
need it.

Imho, this patch can confuse the user-space. Why should we report that,
say, SIGCONT is ignored by the global init?


Even if I am wrong, I believe this change is orthogonal to rhis series,
and should be posted separately.

Oleg.

