Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0BDIKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:10:32 -0500
Received: from smtp.outflux.net ([198.145.64.163]:45191 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab0BDIK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:10:29 -0500
Date: Thu, 4 Feb 2010 00:09:23 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Robin Getz <rgetz@analog.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Paul Moore <paul.moore@hp.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       Etienne Basset <etienne.basset@numericable.fr>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] syslog: distinguish between /proc/kmsg and
 syscalls
Message-ID: <20100204080923.GL19355@outflux.net>
References: <20100202055354.GV19355@outflux.net>
 <4B67C2EA.705@schaufler-ca.com>
 <20100202202054.GW19355@outflux.net>
 <20100202212510.GG32305@us.ibm.com>
 <alpine.LRH.2.00.1002030859220.14592@tundra.namei.org>
 <20100203233643.GI19355@outflux.net>
 <81b0412b1002032358j163d2e3fm2c0353ba3ec2842a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81b0412b1002032358j163d2e3fm2c0353ba3ec2842a@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Thu, Feb 04, 2010 at 08:58:43AM +0100, Alex Riesen wrote:
> > +       /* /proc/kmsg can open be opened by CAP_SYS_ADMIN */
> > +       if (type != 1 && from_file)
> > +               return 0;
> 
> "can open be opened"?

Erk, sorry.  s/open //

James, do you want a patch for that?

-Kees

-- 
Kees Cook
Ubuntu Security Team
