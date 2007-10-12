Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbXJLPbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbXJLPbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 11:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbXJLPbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 11:31:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:51984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344AbXJLPbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 11:31:33 -0400
Date: Fri, 12 Oct 2007 17:31:32 +0200
From: Jan Blunck <jblunck@suse.de>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: mingo@redhat.com, Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: kernel NULL pointer dereference in check_spread+0x0/0x26
Message-ID: <20071012153132.GF8471@hasse.suse.de>
References: <20071012124054.GD8471@hasse.suse.de> <20071012144644.GA17456@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012144644.GA17456@slug>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, Frederik Deweerdt wrote:

> On Fri, Oct 12, 2007 at 02:40:54PM +0200, Jan Blunck wrote:
> > This is with 2.6.23-mm1 and allmodconfig.
> This generates a .config with CONFIG_SCHED_DEBUG=y and
> CONFIG_FAIR_GROUP_SCHED=n (The latter causes parent_entity to return
> NULL).
> Does setting CONFIG_FAIR_GROUP_SCHED=y help?

No, CONFIG_FAIR_GROUP_SCHED=y was set. Or did you mean CONFIG_FAIR_CGROUP_SCHED?
