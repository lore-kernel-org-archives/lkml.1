Return-Path: <linux-kernel-owner+w=401wt.eu-S1751611AbXCYPoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbXCYPoc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 11:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbXCYPob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 11:44:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4356 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751141AbXCYPob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 11:44:31 -0400
Date: Sun, 25 Mar 2007 12:38:50 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com,
       akpm@osdl.org
Subject: Re: [Patch 7/7] IBAC Patch
Message-ID: <20070325123849.GB8550@ucw.cz>
References: <1174666224.11149.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174666224.11149.7.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This is a new Integrity Based Access Control(IBAC) LSM module which 
> bases access control decisions on the new integrity framework services. 
> IBAC is a sample LSM module to help clarify the interaction between 
> LSM and Linux Integrity Modules(LIM).
> 
>    - Updated Kconfig SECURITY_IBAC description
>      and SECURITY_IBAC_BOOTPARAM default value
>    - Prefixed all log messages with "ibac:"
>    - Redefined a couple of 'int' variables as 'static int'
> 
> signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> ---
> Index: linux-2.6.21-rc4-mm1/security/ibac/Kconfig
> ===================================================================
> --- /dev/null
> +++ linux-2.6.21-rc4-mm1/security/ibac/Kconfig
> @@ -0,0 +1,41 @@
> +config SECURITY_IBAC
> +	boolean "IBAC support"
> +	depends on SECURITY && SECURITY_NETWORK && INTEGRITY
> +	help
> +	  Integrity Based Access Control(IBAC) uses the Linux
> +	  Integrity Module(LIM) API calls to verify an executable's
> +	  metadata and data's integrity.  Based on the results,
> +	  execution permission is permitted/denied.  Integrity
> +	  providers may implement the LIM hooks differently.  For
> +	  more information on integrity verification refer to the
> +	  specific integrity provider documentation.

...sounds like pseudosecurity piece of **** whose only purpose is to
prevent computer's owner to hack his own system?

Why do we want it?
						Pavel


> + * Integrity Based Access Control(IBAC) sample LSM module calling LIM hooks

sample?

> +static inline int is_kernel_thread(struct task_struct *tsk)
> +{
> +	return (!tsk->mm) ? 1 : 0;
> +}

Obfuscated C code contest?

						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
