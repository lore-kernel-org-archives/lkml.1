Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbYCRGsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbYCRGsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 02:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbYCRGsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 02:48:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54591 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbYCRGsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 02:48:42 -0400
Date: Mon, 17 Mar 2008 23:48:42 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Smalley <sds@epoch.ncsc.mil>
Cc: casey@schaufler-ca.com, "Serge E. Hallyn" <serue@us.ibm.com>,
       James Morris <jmorris@namei.org>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [PATCH] cgroups: implement device whitelist lsm (v3)
Message-ID: <20080318064842.GA23167@kroah.com>
References: <176755.88432.qm@web36612.mail.mud.yahoo.com> <1205760399.22912.183.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205760399.22912.183.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 09:26:39AM -0400, Stephen Smalley wrote:
> > > The original promise was that LSM would allow kernels to be built that
> > > shed capabilities altogether,
> > 
> > I don't remember that, but it's been a long time so it could be true.
> 
> "One of the explicit requirements to get LSM into the kernel was to have
> the ability to make capabilities be a module.  This allows the embedded
> people to completely remove capabilities, as they really want this.  I
> don't think we can ignore this, no matter how much of a pain in the butt
> it is :)" - Greg KH
> 
> Quoted from:
> http://marc.info/?l=linux-security-module&m=99236500727804&w=2
> 
> Ironically, since that time, capabilities have doubled in size and still
> can't be removed from the core kernel since LSM didn't push the state
> into the security blobs.

Maybe we need to seriously revisit this and perhaps rip capabilities
back out and put it always into the kernel if it's always a requirement.

Comments made 7 years ago might be totally wrong when we have now
learned how this all has worked out...

thanks,

greg k-h
