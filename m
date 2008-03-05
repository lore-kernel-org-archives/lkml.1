Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYCEFcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYCEFcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 00:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYCEFcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 00:32:09 -0500
Received: from namei.org ([69.55.235.186]:53917 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750838AbYCEFcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 00:32:08 -0500
Date: Wed, 5 Mar 2008 16:29:48 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>, Paul Moore <paul.moore@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH-v2 -mm 0/9] LSM-neutral Audit (SELinux audit separation)
In-Reply-To: <20080301194752.GA19636@ubuntu>
Message-ID: <Xine.LNX.4.64.0803051616050.29148@us.intercode.com.au>
References: <20080301194752.GA19636@ubuntu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008, Ahmed S. Darwish wrote:

> A series of 9 patches to let Audit be LSM netural. This is done 
> for proper future audit<->SMACK integration which will also be
> useful for any future LSM.

I've set up a new tree and added these patches with acks etc. collected 
so far.  See

git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git#next

(note that we still need Audit folk to ack patches 7,8 & 9).

This tree is intended for security patches which are not specific to an 
LSM, to ensure that security patches are being tested & managed together.  


- James
-- 
James Morris
<jmorris@namei.org>
