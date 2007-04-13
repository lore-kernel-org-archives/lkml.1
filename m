Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbXDMNrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbXDMNrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbXDMNrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:47:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48463 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbXDMNrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:47:35 -0400
Date: Fri, 13 Apr 2007 08:47:33 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: ebiederm@xmission.com, serue@us.ibm.com, containers@lists.osdl.org,
       viro@ftp.linux.org.uk, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 05/10] add "permit user mounts in new namespace" clone flag
Message-ID: <20070413134732.GB1483@sergelap.austin.ibm.com>
References: <20070412164541.580374744@szeredi.hu> <20070412164620.588752236@szeredi.hu> <20070412203208.GG27772@sergelap.austin.ibm.com> <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com> <E1HcFx1-0001Zr-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HcFx1-0001Zr-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> > Given the existence of shared subtrees allowing/denying this at the mount
> > namespace level is silly and wrong.
> > 
> > If we need more than just the filesystem permission checks can we
> > make it a mount flag settable with mount and remount that allows
> > non-privileged users the ability to create mount points under it
> > in directories they have full read/write access to.
> 
> OK, that makes sense.
> 
> > I don't like the use of clone flags for this purpose but in this
> > case the shared subtress are a much more fundamental reasons for not
> > doing this at the namespace level.
> 
> I'll drop the clone flag, and add a mount flag instead.
> 
> Thanks,
> Miklos

Makes sense, so then on login pam has to spawn a new user namespace and
construct a root fs with no shared subtrees and with the
user-mounts-allowed flag specified?

-serge
