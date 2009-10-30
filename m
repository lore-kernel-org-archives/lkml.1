Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbZJ3J7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbZJ3J7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 05:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbZJ3J7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 05:59:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:55733 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796AbZJ3J7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 05:59:49 -0400
Message-ID: <4AEAB945.2000801@kernel.org>
Date: Fri, 30 Oct 2009 11:00:37 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: Re: linux-next: manual merge of the percpu tree with the kgdb tree
References: <20091030192038.381eba2d.sfr@canb.auug.org.au>
In-Reply-To: <20091030192038.381eba2d.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Stephen Rothwell wrote:
> Just context changes.  I fixed it up (see below) and can carry the
> changes as necessary.
> 
> I do wonder if the local variable name changes in the percpu tree change
> were a good idea?

Yeap, I agree it's not pretty but I couldn't think of better way to do
it.  The changes are almost randomly spread over different subsystems
and coordinating pull/push between all those trees and the percpu tree
would be too painful logistically, so I think it would be better to
channel most of them through the percpu tree and react to clashes that
happen (there shouldn't be too many during single devel cycle and
resolution shouldn't be too hard).

percpu#for-next tree won't be rebased and pulling it into the
conflicting tree should resolve the situation.  Or if carrying the
fixup isn't too painful for you, doing it this way isn't too bad
either.  I can collect the conflict resolutions and send it together
with pull request when the next merge window opens.

> I also needed a further merge fixup (see further below).

Patch looks good to me.

Thanks.

-- 
tejun
