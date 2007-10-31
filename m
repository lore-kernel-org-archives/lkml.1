Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbXJaNmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbXJaNmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 09:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbXJaNmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 09:42:11 -0400
Received: from namei.org ([69.55.235.186]:55871 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754782AbXJaNmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 09:42:10 -0400
Date: Thu, 1 Nov 2007 00:41:08 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Serge Hallyn <sergeh@us.ibm.com>,
       Venkat Yekkirala <vyekkirala@TrustedCS.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Subject: Re: [PATCHv2] selinux: suppress a warning for 64k pages.
In-Reply-To: <20071031164719.77f48d75.sfr@canb.auug.org.au>
Message-ID: <Xine.LNX.4.64.0711010040290.19784@us.intercode.com.au>
References: <20071031145744.6dd02cc7.sfr@canb.auug.org.au>
 <20071031164719.77f48d75.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007, Stephen Rothwell wrote:

> On PowerPC allmodconfig build we get this:
> 
> security/selinux/xfrm.c:214: warning: comparison is always false due to limited range of data type
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  security/selinux/xfrm.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> This version suppresses the warning without ugly ifdefs.


Thanks, Stephen.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-linus


-- 
James Morris
<jmorris@namei.org>
