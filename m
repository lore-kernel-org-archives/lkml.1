Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbXC3Jay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbXC3Jay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 05:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbXC3Jay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 05:30:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36107 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752381AbXC3Jax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 05:30:53 -0400
Date: Fri, 30 Mar 2007 02:30:47 -0700
From: Paul Jackson <pj@sgi.com>
To: Simon Horman <horms@verge.net.au>
Cc: linux-kernel@vger.kernel.org, simon.derr@bull.net
Subject: Re: [PATCH] CPUSETS: add mems to basic usage documentation
Message-Id: <20070330023047.216048a6.pj@sgi.com>
In-Reply-To: <20070330041001.GA20566@verge.net.au>
References: <20070330041001.GA20566@verge.net.au>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman wrote:
> +++ linux-2.6/Documentation/cpusets.txt	2007-03-30 13:03:19.000000000 +0900
> ...
> +Add some mems:
> +# /bin/echo 0-7 > mems

Nice change - thanks.

Acked-by: Paul Jackson <pj@sgi.com>


(I probably would not add a dmesg complaint; we don't usually
do that for ordinary system call failures.  Pay close attention
to the resulting errno - in this case ENOSPC.)

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
