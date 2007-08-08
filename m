Return-Path: <linux-kernel-owner+w=401wt.eu-S937095AbXHHBYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937095AbXHHBYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936295AbXHHBWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:22:40 -0400
Received: from namei.org ([69.55.235.186]:47582 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936572AbXHHBWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:22:38 -0400
Date: Tue, 7 Aug 2007 18:22:15 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Al Viro <viro@ftp.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] fix oops in __audit_signal_info()
In-Reply-To: <20070807230146.GZ21089@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0708071821550.32311@us.intercode.com.au>
References: <20070807230146.GZ21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Al Viro wrote:

> 	Check for audit_signals is misplaced and check for
> audit_dummy_context() is missing; as the result, if we send
> signal to auditd from task with NULL ->audit_context while
> we have audit_signals != 0 we end up with an oops.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: James Morris <jmorris@namei.org>



-- 
James Morris
<jmorris@namei.org>
