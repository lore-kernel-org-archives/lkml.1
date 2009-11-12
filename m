Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbZKLREn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbZKLREn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbZKLREm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:04:42 -0500
Received: from mail.vyatta.com ([76.74.103.46]:33366 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbZKLREl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:04:41 -0500
Date: Thu, 12 Nov 2009 09:04:10 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2] Documentation: rw_lock lessons learned
Message-ID: <20091112090410.43f90569@nehalam>
In-Reply-To: <4AFBEC44.9030409@gmail.com>
References: <4AF9C540.5090403@gmail.com>
	<20091110180646.2e5859a8@nehalam>
	<4AFAEF78.4080807@gmail.com>
	<20091111093724.4f40a48d@nehalam>
	<4AFBEC44.9030409@gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 06:06:44 -0500
William Allen Simpson <william.allen.simpson@gmail.com> wrote:

> +   NOTE! We are working hard to remove reader-writer spinlocks from the
> +   network stack, so please don't add a new one.  (Instead, see
> +   Documentation/RCU/rcu.txt for complete information.)

It is not just networking, so don't single that out.

Also, should mention -RT kernel and locking here (Appendix?)


-- 
