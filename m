Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbYCZXTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbYCZXTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbYCZXTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:19:31 -0400
Received: from namei.org ([69.55.235.186]:52105 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753371AbYCZXTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:19:30 -0400
Date: Thu, 27 Mar 2008 10:18:51 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Roland McGrath <roland@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selinux: remove ptrace_sid
In-Reply-To: <20080326224639.50F8726FA1C@magilla.localdomain>
Message-ID: <Xine.LNX.4.64.0803271018180.5606@us.intercode.com.au>
References: <20080326224639.50F8726FA1C@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Roland McGrath wrote:

> This changes checks related to ptrace to get rid of the ptrace_sid
> tracking.  It's good to disentangle the security model from the
> ptrace implementation internals.  It's sufficient to check against
> the SID of the ptracer at the time a tracee attempts a transition.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> Acked-by: Stephen Smalley <sds@tycho.nsa.gov>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm


-- 
James Morris
<jmorris@namei.org>
