Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab0BDVTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:19:08 -0500
Received: from tundra.namei.org ([65.99.196.166]:57614 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757865Ab0BDVTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:19:04 -0500
Date: Fri, 5 Feb 2010 08:17:59 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <kees.cook@canonical.com>
cc: Alex Riesen <raa.lkml@gmail.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
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
In-Reply-To: <20100204080923.GL19355@outflux.net>
Message-ID: <alpine.LRH.2.00.1002050817120.3356@tundra.namei.org>
References: <20100202055354.GV19355@outflux.net> <4B67C2EA.705@schaufler-ca.com> <20100202202054.GW19355@outflux.net> <20100202212510.GG32305@us.ibm.com> <alpine.LRH.2.00.1002030859220.14592@tundra.namei.org> <20100203233643.GI19355@outflux.net>
 <81b0412b1002032358j163d2e3fm2c0353ba3ec2842a@mail.gmail.com> <20100204080923.GL19355@outflux.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1665246916-1476481985-1265318281=:3356"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-1476481985-1265318281=:3356
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 4 Feb 2010, Kees Cook wrote:

> Hi Alex,
> 
> On Thu, Feb 04, 2010 at 08:58:43AM +0100, Alex Riesen wrote:
> > > +       /* /proc/kmsg can open be opened by CAP_SYS_ADMIN */
> > > +       if (type != 1 && from_file)
> > > +               return 0;
> > 
> > "can open be opened"?
> 
> Erk, sorry.  s/open //
> 
> James, do you want a patch for that?

I guess... and 'opened with' might be better.


-- 
James Morris
<jmorris@namei.org>
--1665246916-1476481985-1265318281=:3356--
