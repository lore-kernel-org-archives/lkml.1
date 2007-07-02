Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbXGBUTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbXGBUTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 16:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbXGBUS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 16:18:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35825 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbXGBUSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 16:18:55 -0400
Date: Mon, 2 Jul 2007 21:15:34 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
Message-ID: <20070702201534.GA4896@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Casey Schaufler <casey@schaufler-ca.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Adrian Bunk <bunk@stusta.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <m1sl86iwkq.fsf@ebiederm.dsl.xmission.com> <997814.45234.qm@web36605.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <997814.45234.qm@web36605.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2007 at 12:31:49PM -0700, Casey Schaufler wrote:
> It's true that the code review for AppArmor has proven difficult.
> That's going to be true of any change to the vfs layer, for any
> reason. Have someone who was there tell you about the original XFS
> proposals some time. Again, it's not LSM's fault.

Utterly wrong comparism.  There haven't been any VFS changes for XFS.
There has been some new functionality in the core kernel, but the
more interesting bits where in the VM (e.g. vmap which is now widely
used).

AA on the other hand just fucks up VFS layering to implement really dumb
semantics.

A better comparism would be to some of the original reiser4 suggestions,
although to be as bad you'd have to look at Hans' whitepapers and not
actually existing code.  And yes, there's a reason his pipedreams never
got anywhere near merged.
