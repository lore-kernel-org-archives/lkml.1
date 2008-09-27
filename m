Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbYI0E0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbYI0E0W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 00:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973AbYI0E0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 00:26:14 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:46302 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbYI0E0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 00:26:13 -0400
Message-ID: <48DDB5BF.2030006@kernel.org>
Date: Fri, 26 Sep 2008 21:25:35 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/6] file capabilities: remove CONFIG_SECURITY_FILE_CAPABILITIES
References: <1222482472-12847-1-git-send-email-serue@us.ibm.com> <7004aef68d149ffb4a11835f37469948496ffc18.1222451103.git.serue@us.ibm.com> <89d3843fc1aaf91ded89d741b2e6d425508e0146.1222451103.git.serue@us.ibm.com>
In-Reply-To: <89d3843fc1aaf91ded89d741b2e6d425508e0146.1222451103.git.serue@us.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
> From: Serge Hallyn <serue@us.ibm.com>
> 
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

Acked-by: Andrew G. Morgan <morgan@kernel.org>

> ---
>  fs/open.c                  |    8 --
>  include/linux/capability.h |    2 -
>  include/linux/init_task.h  |    4 -
>  kernel/capability.c        |  158 --------------------------------------------
>  security/Kconfig           |    9 ---
>  security/commoncap.c       |   53 ---------------
>  6 files changed, 0 insertions(+), 234 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 07da935..6e1cd6e 100644
[...snip...]

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFI3bW9+bHCR3gb8jsRAoD6AKCdF8HNGdT8MPqWUBqrf8+BXGEyZwCfZc2T
+/hD1+FB2fTLae+vEbKpWX0=
=NerD
-----END PGP SIGNATURE-----
