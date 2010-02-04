Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab0BDVvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:51:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932697Ab0BDVvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:51:18 -0500
Subject: Re: [PATCH v2 1/2] syslog: distinguish between /proc/kmsg and
 syscalls
From: Eric Paris <eparis@redhat.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
       Alex Riesen <raa.lkml@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org,
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
In-Reply-To: <20100204213106.GB25497@us.ibm.com>
References: <20100202055354.GV19355@outflux.net>
	 <4B67C2EA.705@schaufler-ca.com> <20100202202054.GW19355@outflux.net>
	 <20100202212510.GG32305@us.ibm.com>
	 <alpine.LRH.2.00.1002030859220.14592@tundra.namei.org>
	 <20100203233643.GI19355@outflux.net>
	 <81b0412b1002032358j163d2e3fm2c0353ba3ec2842a@mail.gmail.com>
	 <20100204080923.GL19355@outflux.net>
	 <alpine.LRH.2.00.1002050817120.3356@tundra.namei.org>
	 <20100204213106.GB25497@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 16:49:12 -0500
Message-ID: <1265320152.5447.17.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 15:31 -0600, Serge E. Hallyn wrote:
> Quoting James Morris (jmorris@namei.org):
> > On Thu, 4 Feb 2010, Kees Cook wrote:
> > 
> > > Hi Alex,
> > > 
> > > On Thu, Feb 04, 2010 at 08:58:43AM +0100, Alex Riesen wrote:
> > > > > +       /* /proc/kmsg can open be opened by CAP_SYS_ADMIN */
> > > > > +       if (type != 1 && from_file)
> > > > > +               return 0;
> > > > 
> > > > "can open be opened"?
> > > 
> > > Erk, sorry.  s/open //
> > > 
> > > James, do you want a patch for that?
> > 
> > I guess... and 'opened with' might be better.
> 
> I'd still as mentioned yesterday prefer "requires CAP_SYS_ADMIN to open"
> Otherwise, every time I see the comment I expect stricter requirements,
> not laxer ones, on the other actions.  However, I think with the second
> patch switching 1 for a meaningful name, the comment isn't even necessary
> or noticable any more.

Agreed, the names make the function understandable, the comment confused
the mess out of me.

