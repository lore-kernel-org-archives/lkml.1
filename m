Return-Path: <linux-kernel-owner+w=401wt.eu-S933948AbXCQKLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948AbXCQKLJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 06:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933954AbXCQKLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 06:11:08 -0400
Received: from saeurebad.de ([85.214.36.134]:38625 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933691AbXCQKLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 06:11:07 -0400
X-Greylist: delayed 1272 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Mar 2007 06:11:07 EDT
Date: Sat, 17 Mar 2007 10:45:36 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rc4] kernel/exit: Fix a comment and code contradiction
Message-ID: <20070317093856.GB32496@leiferikson>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20070317062132.GA11326@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070317062132.GA11326@Ahmed>
X-IMAPbase: 1174054804 1
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Mar 17, 2007 at 08:21:32AM +0200, Ahmed S. Darwish wrote:
> Comment in release_task() claims that group leader's parent process 
> is signalled only if it desires so, which is not true.

AFAIS, `if it wants notification' means, it does not ignore its children
via SIG_IGN als handler for SIGCHLD.

do_notify_parent() checks if the parent wants to get informed about the
child states.

- Johannes
