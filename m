Return-Path: <linux-kernel-owner+w=401wt.eu-S1161224AbXDSJEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161224AbXDSJEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 05:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993209AbXDSJEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 05:04:54 -0400
Received: from koto.vergenet.net ([210.128.90.7]:39815 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161224AbXDSJEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 05:04:53 -0400
Date: Thu, 19 Apr 2007 18:04:36 +0900
From: Simon Horman <horms@verge.net.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Wensong Zhang <wensong@linux-vs.org>,
       Julian Anastasov <ja@ssi.bg>
Subject: Re: [PATCH] ipv4/ipvs: Convert to kthread API
Message-ID: <20070419090435.GB26050@verge.net.au>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <11769696262330-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11769696262330-git-send-email-ebiederm@xmission.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 01:58:57AM -0600, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Modify startup of ipvs sync threads to use kthread_run
> instead of a weird combination of calling kernel_thread
> to start a fork_sync_thread whose hole purpose in life was
> to call kernel_thread again starting the actually sync thread
> which called daemonize.
> 
> To use kthread_run I had to move the name calcuation from
> sync_thread into start_sync_thread resulting in a small
> amount of code motion.
> 
> The result is simpler and more maintainable piece of code.

Thanks Eric, I'll review this and get back to you shortly.

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

