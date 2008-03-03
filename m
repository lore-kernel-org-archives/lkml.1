Return-Path: <linux-kernel-owner+w=401wt.eu-S1761012AbYCCVUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761012AbYCCVUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbYCCVUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:20:35 -0500
Received: from namei.org ([69.55.235.186]:42034 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753651AbYCCVUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:20:34 -0500
Date: Tue, 4 Mar 2008 08:18:47 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>, Paul Moore <paul.moore@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 1/9] LSM: Introduce inode_getsecid and ipc_getsecid hooks
In-Reply-To: <20080301195109.GB19636@ubuntu>
Message-ID: <Xine.LNX.4.64.0803040818190.8529@us.intercode.com.au>
References: <20080301194752.GA19636@ubuntu> <20080301195109.GB19636@ubuntu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008, Ahmed S. Darwish wrote:

> Introduce inode_getsecid(inode, secid) and ipc_getsecid(ipcp, secid)
> LSM hooks. These hooks will be used instead of similar exported 
> SELinux interfaces.
> 
> Let {inode,ipc,task}_getsecid hooks set the secid to 0 by default 
> if CONFIG_SECURITY is not defined or if the hook is set to 
> NULL (dummy). This is done to notify the caller that no valid 
> secid exists.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

Acked-by: James Morris <jmorris@namei.org>

-- 
James Morris
<jmorris@namei.org>
