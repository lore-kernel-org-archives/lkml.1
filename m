Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbXH1XFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbXH1XFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 19:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXH1XFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 19:05:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46903 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbXH1XFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 19:05:07 -0400
Date: Wed, 29 Aug 2007 00:04:59 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
Message-ID: <20070828230459.GA15937@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 04:40:15PM -0600, Eric W. Biederman wrote:
> +When:	September 2010
> +Option: CONFIG_SYSCTL_SYSCALL
> +Why:	The same information is available in a more convenient from
> +	/proc/sys, and none of the sysctl variables appear to be
> +	important performance wise.
> +
> +	Binary sysctls are a long standing source of subtle kernel
> +	bugs and security issues.
> +
> +	When I looked several months ago all I could find after
> +	searching several distributions were 5 user space programs and
> +	glibc (which falls back to /proc/sys) using this syscall.

Umm, no way we're ever going to remove a syscall like this.  Please
stop this deprecration crap.  Just make sure no ones adds more binary
sysctls.

