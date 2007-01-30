Return-Path: <linux-kernel-owner+w=401wt.eu-S1752657AbXA3KZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbXA3KZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 05:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbXA3KZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 05:25:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44156 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbXA3KZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 05:25:37 -0500
Date: Tue, 30 Jan 2007 10:25:08 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       jmorris@namei.org
Subject: Re: [PATCH] sysctl selinux: Don't look at table->de
Message-ID: <20070130102508.GA10526@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
	tglx@linutronix.de, linux-kernel@vger.kernel.org,
	selinux@tycho.nsa.gov, jmorris@namei.org
References: <1170096231.8720.102.camel@moss-spartans.epoch.ncsc.mil> <493253.19989.qm@web36606.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493253.19989.qm@web36606.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 11:08:39AM -0800, Casey Schaufler wrote:
> Alternativly you could move the SELinux specific
> bits out of /proc/self/attr into an equivalent
> /selinux/self/attr and avoid that /proc dependency.

Why?  procfs is essential for any kind of fullblown linux system,
and the selinux actually fits into the original procfs intention,
unlike all the other junk we've added over the years.

