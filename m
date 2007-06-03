Return-Path: <linux-kernel-owner+w=401wt.eu-S1752940AbXFCWfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbXFCWfz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 18:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXFCWft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 18:35:49 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:43002 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbXFCWfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 18:35:48 -0400
Date: Sun, 3 Jun 2007 15:34:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: Re: [PATCH 05/19] kbuild: document cc-fullversion
Message-Id: <20070603153419.be0bcf91.randy.dunlap@oracle.com>
In-Reply-To: <20070603204603.GE9240@uranus.ravnborg.org>
References: <20070603204603.GE9240@uranus.ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007 22:46:03 +0200 Sam Ravnborg wrote:

> Subject: [PATCH 05/19] kbuild: document cc-fullversion
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Mon, 28 May 2007 22:26:55 +0200
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  Documentation/kbuild/makefiles.txt |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
> index bb5306e..c6d9a35 100644
> --- a/Documentation/kbuild/makefiles.txt
> +++ b/Documentation/kbuild/makefiles.txt
> @@ -501,6 +501,20 @@ more details, with real examples.
>  	The third parameter may be a text as in this example, but it may also
>  	be an expanded variable or a macro.
>  
> +    cc-fullversion
> +	cc-fullversion is usefull when the exact version of gcc is needed.

                          useful

> +	One typical use-case is when a specific GCC version is broken.
> +	cc-fullversion points out a more specific version than cc-version does.
> +
> +	Example:
> +		#arch/powerpc/Makefile
> +		$(Q)if test "$(call cc-fullversion)" = "040200" ; then \
> +			echo -n '*** GCC-4.2.0 cannot compile the 64-bit powerpc ' ; \
> +			false ; \
> +		fi
> +
> +	In this example for a specific GCC version the build will error out explaining
> +	the user why it stops.

        to the user why  it stops.
>  
>  === 4 Host Program support
>  
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
