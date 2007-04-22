Return-Path: <linux-kernel-owner+w=401wt.eu-S1030870AbXDVUSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030870AbXDVUSj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 16:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030908AbXDVUSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 16:18:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60834 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030870AbXDVUSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 16:18:38 -0400
Date: Sun, 22 Apr 2007 21:18:24 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] arm ecard: Conver to use the kthread API.
Message-ID: <20070422201824.GB23015@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
	Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
	Russell King <rmk+kernel@arm.linux.org.uk>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <11769695722834-git-send-email-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11769695722834-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 01:58:43AM -0600, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> This patch modifies the startup of kecardd to use
> kthread_run not a kernel_thread combination of kernel_thread
> and daemonize.  Making the code slightly simpler and more
> maintainable.

Looks good.  Given that this is non-modular and there's no
exit function there is no need for further action.

