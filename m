Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbYAOKkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbYAOKkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYAOKkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:40:10 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43307 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbYAOKkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:40:08 -0500
To: serue@us.ibm.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       serue@us.ibm.com, viro@ftp.linux.org.uk, ebiederm@xmission.com,
       kzak@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org
In-reply-to: <20080114231340.GG6704@sergelap.austin.ibm.com>
	(serue@us.ibm.com)
Subject: Re: [patch 8/9] unprivileged mounts: propagation: inherit owner
	from parent
References: <20080108113502.184459371@szeredi.hu> <20080108113632.895453887@szeredi.hu> <20080114231340.GG6704@sergelap.austin.ibm.com>
Message-Id: <E1JEjCG-0000wz-BS@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 15 Jan 2008 11:39:08 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Miklos Szeredi (miklos@szeredi.hu):
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > On mount propagation, let the owner of the clone be inherited from the
> > parent into which it has been propagated.  Also if the parent has the
> > "nosuid" flag, set this flag for the child as well.
> 
> What about nodev?

Hmm, I think the nosuid thing is meant to prevent suid mounts being
introduced into a "suidless" namespace.  This doesn't apply to dev
mounts, which are quite safe in a suidless environment, as long as the
user is not able to create devices.  But that should be taken care of
by capability tests.

I'll update the description.

Thanks,
Miklos
