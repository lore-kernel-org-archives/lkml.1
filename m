Return-Path: <linux-kernel-owner+w=401wt.eu-S1760926AbYCDDed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926AbYCDDed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbYCDDeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:34:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:17317 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbYCDDeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:34:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=nUPTfnkgQhsbIQxE+YHlHuzeinAOrDIoRdk0fudgeoCYO3e5xvt3UQdEUJIY3J3rRlKKec2y4ch/MuVC4qtF2kRfL2NgaBAo6cRjmQ1z5ox/9DYp/q6fCsKQ+92MsZJxgF1pdLDAddf0OzsHgMkq99WrWGZQi1lU0Cr/i4L+XPU=
Date: Tue, 4 Mar 2008 05:31:09 +0200
To: Paul Moore <paul.moore@hp.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 7/9] Audit: internally use the new LSM audit hooks
Message-ID: <20080304033109.GA28637@ubuntu>
References: <20080301194752.GA19636@ubuntu> <20080301200111.GH19636@ubuntu> <200803031851.41978.paul.moore@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803031851.41978.paul.moore@hp.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 06:51:41PM -0500, Paul Moore wrote:
> On Saturday 01 March 2008 3:01:11 pm Ahmed S. Darwish wrote:
...
> >
> >  audit.c       |    7 ------
> >  auditfilter.c |   61
> > ++++++++++++++++------------------------------------------ auditsc.c 
> >    |    9 +++-----
> >  3 files changed, 22 insertions(+), 55 deletions(-)
> 
> For some reason some of your patches are not coming through with correct 
> diffstats (notice the lack of a path relative to the kernel base?).  
> Don't worry too much about it as it's not grounds to reject the patch 
> (at least in my mind) but it's worth looking into on your end for the 
> next time you submit patches.
> 

Yes, it's something weird. I've generated all of those diffstats (including
the right ones) in the same way. Luckily the problem is reproduceable,
I'll check the latest upstream diffstat version and see what happens.

> > Andrew, please atomically merge patch #7 and patch #8. Although
> > a system with patch7 and without patch8 will be compiled fine,
> > the SELinux Audit hooks are not set up yet. This means below
> > audit hooks will point to the dummy hooks instead of SELinux
> > ones even if SELinux is enabled.
> >
> > I could not setup the SELinux hooks first cause they have
> > the same name of the old exported SELinux interface with a
> > difference of one parameter.
> 
> In cases like this where you need patches applied atomically to ensure 
> correct operation you can always combine the two patches into one 
> (assuming they are still small enough to be posted, which shouldn't be 
> a problem here).  Small patches are nice and easy to review, but that 
> doesn't mean you have to break everything up if it is awkward.
> 

I'll keep that in mind.

> I've looked over patches #7, #8, and #9 and they look okay to me, but 
> I'm not tagging them 'Reviewed-by' because they go beyond areas of the 
> kernel that I feel comfortable reviewing at this point.  Rest assured 
> there are other on the To/CC line that can help you out (I see James 
> Morris already Ack'd your entire patch set).
> 
> Thanks for all your work on this, it's a nice improvement.
> 

I'm also very thankful for such a nice review and caring explanations!.

Best,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

