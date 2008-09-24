Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbYIXFAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbYIXFAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 01:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbYIXFAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 01:00:07 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:59856 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYIXFAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 01:00:05 -0400
Message-ID: <48D9C92F.5090908@kernel.org>
Date: Tue, 23 Sep 2008 21:59:27 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       James Morris <jmorris@redhat.com>, Andreas Gruenbacher <agruen@suse.de>,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 2/2] file capabilities: remove	CONFIG_SECURITY_FILE_CAPABILITIES
References: <20080924020432.GA25997@us.ibm.com> <20080924020526.GA26058@us.ibm.com>
In-Reply-To: <20080924020526.GA26058@us.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Acked-by: Andrew G. Morgan <morgan@kernel.org>

Cheers

Andrew

Serge E. Hallyn wrote:
> Remove the option to compile the kernel without file capabilities.  Not
> compiling file capabilities actually makes the kernel less safe, as it
> includes the possibility for a task changing another task's capabilities.
> 
> Some are concerned that userspace tools (and user education) are not
> up to the task of properly configuring file capabilities on a system.
> For those cases, there is now the ability to boot with the no_file_caps
> boot option.  This will prevent file capabilities from being used in
> the capabilities recalculation at exec, but will not change the rest
> of the kernel behavior which used to be switchable using the
> CONFIG_SECURITY_FILE_CAPABILITIES option.
> 
> Signed-off-by: Serge Hallyn <serue@us.ibm.com>
> ---
>  fs/open.c                  |    8 --
>  include/linux/capability.h |    2 -
>  include/linux/init_task.h  |    4 -
>  kernel/capability.c        |  158 --------------------------------------------
>  security/Kconfig           |    9 ---
>  security/commoncap.c       |   53 ---------------
>  6 files changed, 0 insertions(+), 234 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFI2ckn+bHCR3gb8jsRAh1QAJ9yEYEdnUgOn5w18u6DgXNKCnAbWACgnq8j
70Oa+pgYJpRVsIPMSJcUGhY=
=26lW
-----END PGP SIGNATURE-----
