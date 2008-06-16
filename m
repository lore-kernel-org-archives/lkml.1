Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYFPTha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYFPTha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 15:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYFPThU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 15:37:20 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36642 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbYFPThT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 15:37:19 -0400
Date: Mon, 16 Jun 2008 12:36:14 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] configfs: module reference counting rules
Message-ID: <20080616193614.GB6441@mail.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20080612235410.GC4012@localdomain> <20080613033309.GE20581@mail.oracle.com> <20080613095159.GH30804@localhost> <20080613202605.GD20576@mail.oracle.com> <20080613222744.GB4153@localdomain> <20080614084701.GA9657@mail.oracle.com> <20080616123912.GR30804@localhost> <20080616180643.GC9657@mail.oracle.com> <20080616181428.GW30804@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616181428.GW30804@localhost>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 08:14:28PM +0200, Louis Rilling wrote:
> With a preemptible kernel, after module_put(self) the few assembly instructions
> cleaning up the stack before returning to the caller can be called after the
> memory allocated for the module has been freed. Which will make the kernel
> crash.

	Ahh, but if you are running a preemptible kernel, you've already
made your first mistake :-)

Joel

-- 

"Vote early and vote often." 
        - Al Capone

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
