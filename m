Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYCQWeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYCQWeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 18:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbYCQWeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 18:34:10 -0400
Received: from namei.org ([69.55.235.186]:48139 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753197AbYCQWeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 18:34:09 -0400
Date: Tue, 18 Mar 2008 09:32:30 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Eric Paris <eparis@redhat.com>
cc: Adrian Bunk <bunk@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make selinux_parse_opts_str() static
In-Reply-To: <1205789761.2431.1.camel@localhost.localdomain>
Message-ID: <Xine.LNX.4.64.0803180932090.10104@us.intercode.com.au>
References: <20080317202923.GC9550@cs181133002.pp.htv.fi>
 <1205789761.2431.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2008, Eric Paris wrote:

> On Mon, 2008-03-17 at 22:29 +0200, Adrian Bunk wrote:
> > This patch makes the needlessly global selinux_parse_opts_str() static.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Ack-ed by: Eric Paris <eparis@redhat.com>

ITYM Acked-by :-)

Applied to for-linus.


> 
> whoops, sorry.
> 
> > ---
> > 42740a04634e3a4362a688b29ad31ee87c940ff7 diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index 4bf4807..41a049f 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -800,7 +800,8 @@ static void selinux_sb_clone_mnt_opts(const struct super_block *oldsb,
> >  	mutex_unlock(&newsbsec->lock);
> >  }
> >  
> > -int selinux_parse_opts_str(char *options, struct security_mnt_opts *opts)
> > +static int selinux_parse_opts_str(char *options,
> > +				  struct security_mnt_opts *opts)
> >  {
> >  	char *p;
> >  	char *context = NULL, *defcontext = NULL;
> > 
> 

-- 
James Morris
<jmorris@namei.org>
