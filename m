Return-Path: <linux-kernel-owner+w=401wt.eu-S942110AbYCSW7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942110AbYCSW7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936954AbYCSVYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:24:18 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33591 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766016AbYCSVYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:24:16 -0400
Date: Tue, 18 Mar 2008 18:41:34 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>
Subject: Re: [PATCH 4/5] don't panic if /sbin/init exits or killed
Message-ID: <20080318154134.GA3493@tv-sign.ru>
References: <20080316155453.GA20845@tv-sign.ru> <1205850955.6466.61.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205850955.6466.61.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18, Stephen Smalley wrote:
> 
> On Sun, 2008-03-16 at 18:54 +0300, Oleg Nesterov wrote:
> > If the buggy init exits, the kernel panics. I see no point for this. It is very
> > possible that the system is still usable enough, at least to read the logs and
> > prepare the bug report.
> 
> At present, init with SELinux support will exit with an error status if
> it cannot successfully load the initial policy if the system is in
> enforcing mode, with the expectation that the kernel will then panic.
> 
> We might argue about whether that is correct (having it explicitly halt
> makes more sense to me, but I didn't write the init patch), but it has
> been the behavior in Fedora and Debian for quite some time.

OK, thanks. It's a pity ;)

Please ignore this patch then.

Oleg.

