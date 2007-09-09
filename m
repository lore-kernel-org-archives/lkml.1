Return-Path: <linux-kernel-owner+w=401wt.eu-S1759168AbXIISxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbXIISxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 14:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbXIISxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 14:53:03 -0400
Received: from ns1.suse.de ([195.135.220.2]:42555 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758643AbXIISxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 14:53:00 -0400
Date: Sun, 9 Sep 2007 20:52:58 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-arch@vger.kernel.org,
       discuss@x86-64.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [discuss] [patch 3/5] Use extended crashkernel command line on
	x86_64
Message-ID: <20070909185257.GA10600@suse.de>
Mail-Followup-To: Yinghai Lu <yhlu.kernel@gmail.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Vivek Goyal <vgoyal@in.ibm.com>, linux-arch@vger.kernel.org,
	discuss@x86-64.org, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <20070909083914.065380136@strauss.suse.de> <20070909083914.951336895@strauss.suse.de> <86802c440709091027o32a63d11w629bad87abcc19c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440709091027o32a63d11w629bad87abcc19c2@mail.gmail.com>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu <yhlu.kernel@gmail.com> [2007-09-09 19:27]:
> >
> > +#ifdef CONFIG_KEXEC
> ...
> 
> CONFIG_KEXEC or CONFIG_CRASH_DUMP?

Good question. The crashkernel parameter was CONFIG_KEXEC before, and
I also wondered why, but I didn't change this because maybe there's
some reason I don't know.

Vivek, do you know why this was CONFIG_KEXEC?


Thanks,
   Bernhard
