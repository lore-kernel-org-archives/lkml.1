Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0BBUWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:22:16 -0500
Received: from smtp.outflux.net ([198.145.64.163]:59254 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab0BBUWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:22:12 -0500
Date: Tue, 2 Feb 2010 12:20:54 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@redhat.com>, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Robin Getz <rgetz@analog.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Paul Moore <paul.moore@hp.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       Etienne Basset <etienne.basset@numericable.fr>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] syslog: distinguish between /proc/kmsg and syscalls
Message-ID: <20100202202054.GW19355@outflux.net>
References: <20100202055354.GV19355@outflux.net>
 <4B67C2EA.705@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B67C2EA.705@schaufler-ca.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 01, 2010 at 10:15:06PM -0800, Casey Schaufler wrote:
> Might I suggest that you use a term other than "context" in this patch?
> I recognize that it is the proper word, but the term has significant and
> specific meaning in SELinux, and some of that has spilled over into the
> LSM in general. I expect that there might be confusion if it is used to
> denote something other than an SELinux "context". Perhaps "method", "type",
> or "scheme".

Yeah, I cringed at "context" too, but since "type" is pretty overloaded
and it was already an argument there, I figured maybe it wouldn't be
too bad.

> > -extern int cap_syslog(int type);
> > +extern int cap_syslog(int type, int context);

Perhaps "source" or "origin"?  "mode" is too overloaded with file modes.
Maybe a future patch can change "type" to "action" too.

-Kees

-- 
Kees Cook
Ubuntu Security Team
