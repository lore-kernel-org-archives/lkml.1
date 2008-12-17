Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752404AbYLQS4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbYLQS4U (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbYLQS4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:56:06 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52371 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbYLQS4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:56:06 -0500
Subject: Re: [PATCH 1/2] mqueue ns: move mqueue_mnt into struct
	ipc_namespace
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Linux Containers <containers@lists.osdl.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20081217185241.GA25250@us.ibm.com>
References: <20081217175513.GA23291@us.ibm.com>
	 <20081217175531.GA23331@us.ibm.com> <1229538964.17206.421.camel@nimitz>
	 <20081217185241.GA25250@us.ibm.com>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 10:55:54 -0800
Message-Id: <1229540154.17206.428.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 12:52 -0600, Serge E. Hallyn wrote:
> > > +void mq_init_ns(struct ipc_namespace *ns) {
> > > +   ns->mq_queues_count  = 0;
> > > +   ns->mq_queues_max    = DFLT_QUEUESMAX;
> > > +   ns->mq_msg_max       = DFLT_MSGMAX;
> > > +   ns->mq_msgsize_max   = DFLT_MSGSIZEMAX;
> > > +   ns->mq_mnt           = mntget(init_ipc_ns.mq_mnt);
> > > +}
> > 
> > Heh, I read that as a structure definition at first!  Could you put
> that
> > bracket on a new line.
> 
> That's actually taken care of in the followup patch - same with
> mq_exit_ns.  Sorry about that.  (Still I'd rather not bother with
> the patch flux to change it just in this patch, since whenever
> I do that I inevitably mess up something else)

Ahh, ok.  I guess it is OK since it is temporary.

-- Dave

