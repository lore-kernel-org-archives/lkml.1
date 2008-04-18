Return-Path: <linux-kernel-owner+w=401wt.eu-S1759603AbYDRSLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603AbYDRSLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 14:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759462AbYDRSLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 14:11:21 -0400
Received: from web36602.mail.mud.yahoo.com ([209.191.85.19]:29541 "HELO
	web36602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759456AbYDRSLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 14:11:20 -0400
X-YMail-OSG: ZTr3NAcVM1nbYWWSwdm83ROOTmPHO7_XCyLsD0EUItOjhyQr5JQ6qh7euS5OsnAnMkPntOolevzYXsgtpCklhZ4aYtdTcobd4ZipRUyjiDHq8Vp_Qqv1Yz63B9Y-
X-RocketYMMF: rancidfat
Date: Fri, 18 Apr 2008 11:11:14 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Security testing tree patch review for 2.6.26
To: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1208430369-23156-1-git-send-email-jmorris@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <834491.21069.qm@web36602.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- James Morris <jmorris@namei.org> wrote:

> 
> Please review the following security patches for 2.6.26, which have
> been undergoing testing in the "next" tree and affect multiple LSMs.

I have done basic testing on this patchset and have not
encountered any problems from the Smack side. I have not
tested without Smack nor by implication with SELinux.


> 
> The following changes since commit 4b119e21d0c66c22e8ca03df05d9de623d0eb50f:
>   Linus Torvalds (1):
>         Linux 2.6.25
> 
> are available in the git repository at:
> 
>  
>
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
> for-linus
> 
> Ahmed S. Darwish (10):
>       LSM: Introduce inode_getsecid and ipc_getsecid hooks
>       SELinux: setup new inode/ipc getsecid hooks
>       Audit: use new LSM hooks instead of SELinux exports
>       Netlink: Use generic LSM hook
>       SELinux: remove redundant exports
>       LSM/Audit: Introduce generic Audit LSM hooks
>       Audit: internally use the new LSM audit hooks
>       SELinux: use new audit hooks, remove redundant exports
>       Audit: Final renamings and cleanup
>       Security: Introduce security= boot parameter
> 
> James Morris (2):
>       Tell git about security/selinux/include/audit.h
>       security: fix up documentation for security_module_enable
> 
>  Documentation/kernel-parameters.txt |    6 ++
>  include/linux/audit.h               |   29 ++++++++
>  include/linux/security.h            |  114 +++++++++++++++++++++++++++++-
>  include/linux/selinux.h             |  134
> -----------------------------------
>  kernel/audit.c                      |   24 +++----
>  kernel/audit.h                      |   25 -------
>  kernel/auditfilter.c                |   99 ++++++++++----------------
>  kernel/auditsc.c                    |   74 ++++++++++---------
>  net/netlink/af_netlink.c            |    3 +-
>  security/dummy.c                    |   51 +++++++++++++-
>  security/security.c                 |   73 +++++++++++++++++++-
>  security/selinux/exports.c          |   42 -----------
>  security/selinux/hooks.c            |   34 ++++++++-
>  security/selinux/include/audit.h    |   65 +++++++++++++++++
>  security/selinux/ss/services.c      |   45 +++++++++---
>  security/smack/smack.h              |    2 +
>  security/smack/smack_lsm.c          |    7 ++-
>  security/smack/smackfs.c            |   11 +++-
>  18 files changed, 503 insertions(+), 335 deletions(-)
>  create mode 100644 security/selinux/include/audit.h
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
