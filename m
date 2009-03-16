Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762321AbZCPXRg (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 16 Mar 2009 19:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbZCPXRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 19:17:25 -0400
Received: from mail-bw0-f175.google.com ([209.85.218.175]:59684 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbZCPXRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 19:17:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qtN/NgCmK5bvHsN4DfuZ2/9CvOXr5xnH4QE0kS4A7QZeo0Klcpyf54b6NQIP2EN4/P
         aC61czs4HkRwn9JtM+Vms/c4ov57KInFYDSbsZHXPWqpbvMO8xI6UEiWCU2VEr1A1pVW
         GRe6P28aPlFZup0BBmq//ZVjc9MPNajMazB+U=
MIME-Version: 1.0
In-Reply-To: <20090316231340.GC15522@us.ibm.com>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com>
	 <20090312161047.GA15209@us.ibm.com>
	 <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com>
	 <20090313175848.GB27891@fieldses.org>
	 <f44001920903131137j158c5f76y6a71b58ee964df77@mail.gmail.com>
	 <20090313190002.GA16025@us.ibm.com>
	 <1237227705.1035.93.camel@localhost.localdomain>
	 <20090316184926.GA6729@us.ibm.com>
	 <1237237216.1035.195.camel@localhost.localdomain>
	 <20090316231340.GC15522@us.ibm.com>
Date: Tue, 17 Mar 2009 02:17:20 +0300
Message-ID: <f44001920903161617l61618f5br4fc9de4a021bd417@mail.gmail.com>
Subject: =?KOI8-R?Q?Re=3A_=EF=D4=D7=C5=D4=3A_VFS=2C_NFS_security_bug=3F_Should_CAP=5FMK?=
	=?KOI8-R?Q?NOD_and_CAP=5FLINUX=5FIMMUTABLE_be_added_to_CAP=5FFS=5FMASK=3F?=
From: Igor Zhbanov <izh1979@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
   "J. Bruce Fields" <bfields@fieldses.org>,
   Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
   viro@zeniv.linux.org.uk, neilb@suse.de, Trond.Myklebust@netapp.com,
   David Howells <dhowells@redhat.com>, Andrew Morgan <morgan@kernel.org>,
   James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
   SELinux <selinux@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyway, please commit changes to linux-2.4 too.

fs/nfsd/auth.c for CAP_NFSD_MASK:
#define	CAP_NFSD_MASK (CAP_FS_MASK|CAP_TO_MASK(CAP_SYS_RESOURCE))

and

include/linux/capability.h for CAP_FS_MASK:
#define CAP_FS_MASK          0x1f
