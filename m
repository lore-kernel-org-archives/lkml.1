Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbYIVTFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbYIVTFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 15:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbYIVTFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 15:05:04 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:33039 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYIVTFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 15:05:02 -0400
Date: Mon, 22 Sep 2008 12:03:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       James Morris <jmorris@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       Andreas Gruenbacher <agruen@suse.de>, Andrew Morton <akpm@osdl.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 2/2] file capabilities: turn on by default
Message-Id: <20080922120347.60a9171a.randy.dunlap@oracle.com>
In-Reply-To: <20080922184901.GA3688@us.ibm.com>
References: <20080922184835.GA2826@us.ibm.com>
	<20080922184901.GA3688@us.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 13:49:01 -0500 Serge E. Hallyn wrote:

> 
> Now that file capabilities can be turned off at boot, go ahead
> and compile them into the kernel by default by making
> CONFIG_SECURITY_FILE_CAPABILITIES=y the default.

Hi,

How much code does this add to everyone's kernel?

> Note that the boot flag no_file_caps must be specified to turn
> file capabilities off, as by default they are on.  So the
> default behavior is in fact changed.

If most people want this enable, using 'no_file_caps' makes
some sense.  OTOH, if most people don't want/use it, then
having a 'file_caps_on' option would make more sense.

Do you have any (unbiased :) ideas about this?

Thanks.

> Signed-off-by: Serge Hallyn <serue@us.ibm.com>
> Acked-by: Andrew G. Morgan <morgan@kernel.org>
> ---
>  security/Kconfig |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/security/Kconfig b/security/Kconfig
> index 5592939..6fbb233 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -75,12 +75,15 @@ config SECURITY_NETWORK_XFRM
>  
>  config SECURITY_FILE_CAPABILITIES
>  	bool "File POSIX Capabilities"
> -	default n
> +	default y
>  	help
>  	  This enables filesystem capabilities, allowing you to give
>  	  binaries a subset of root's powers without using setuid 0.
>  
> -	  If in doubt, answer N.
> +	  You can still boot with the no_file_caps option to disable
> +	  file capabilities.
> +
> +	  If in doubt, answer Y.
>  
>  config SECURITY_ROOTPLUG
>  	bool "Root Plug Support"


---
~Randy
