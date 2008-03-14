Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbYCNOmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbYCNOmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYCNOmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:42:13 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44267 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbYCNOmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:42:12 -0400
Date: Fri, 14 Mar 2008 09:42:09 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Pavel Emelyanov <xemul@openvz.org>,
       James Morris <jmorris@namei.org>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Greg KH <greg@kroah.com>,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
Message-ID: <20080314144209.GF9741@sergelap.austin.ibm.com>
References: <20080313131818.GA9771@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140049270.9059@us.intercode.com.au> <20080313143803.GA11265@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140925410.30342@us.intercode.com.au> <20080313224616.GA9139@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803141046340.1545@us.intercode.com.au> <20080314014121.GA8320@sergelap.austin.ibm.com> <47DA4533.8030106@openvz.org> <20080314135817.GE8744@sergelap.austin.ibm.com> <6599ad830803140712i1f9dede3yb0be99528934d974@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830803140712i1f9dede3yb0be99528934d974@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On Fri, Mar 14, 2008 at 6:58 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> >  James and Stephen agree with your LSM qualms.  I suppose we could add
> >  cgroups next to the lsm hooks.  I suspect Paul Menage would complain
> >  about that (Paul?),
> 
> Depends on what you mean by "add cgroups to the LSM hooks". Could you
> expand on that?

cgroup hooks next to the lsm hooks.  So in fs/namei.c where there are
security_inode_permission() hooks, there would also be
cgroup_inode_permission() hooks to let the devices cgroup mediate the
access.  Well, in permission(), probably not in exec_permission_lite()
since that's probalby not a device access  :)

So far it looks like everyone likes that, so as long as you don't nack I
guess that'll be the way to go.

thanks,
-serge
