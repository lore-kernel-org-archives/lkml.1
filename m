Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab0CEKnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 05:43:35 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:40135 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab0CEKnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 05:43:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=x-authentication-warning:to:cc:subject:references:from:date
         :in-reply-to:message-id:lines:user-agent:mime-version:content-type;
        b=U3dFkgj+woje3CuV8lTRBabF8GwH9UXVuQyiVFONCJzU9vyMzx+WgP+wiQQS2g1yCK
         FQafg3AYMsN3WAq5R4/QW912L9l+oYfO+P/N7TBsTODxyAb6NIuimigFzDrY+OuPqJwA
         eeJBNqr/54kQAS49sw2jmzvWiGTzxSaSmK1Ys=
To: Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Johannes Sixt <j.sixt@viscovery.net>
Subject: Re: [PATCH 1/1] gitignore: do not ignore include/linux/
References: <4B90CBE5.9090102@viscovery.net>
	<1267780845-10547-1-git-send-email-jslaby@suse.cz>
From: Jakub Narebski <jnareb@gmail.com>
Date: Fri, 05 Mar 2010 02:43:29 -0800 (PST)
In-Reply-To: <1267780845-10547-1-git-send-email-jslaby@suse.cz>
Message-ID: <m3pr3jkq26.fsf@localhost.localdomain>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> writes:

> linux entry in .gitignore means that everything in include/linux/
> gets ignored with git 1.7.
> 
> Prepend a slash to entries which are toplevel to avoid that
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Johannes Sixt <j.sixt@viscovery.net>
> ---
>  .gitignore |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/.gitignore b/.gitignore
> index efab0eb..fe6ebb9 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -34,16 +34,16 @@ modules.builtin
>  #
>  # Top-level generic files
>  #
> -tags
> -TAGS
> -linux
> -vmlinux
> -vmlinuz
> -System.map
> -Module.markers
> -Module.symvers
> -!.gitignore
> -!.mailmap
> +/tags
> +/TAGS
> +/linux
> +/vmlinux
> +/vmlinuz
> +/System.map
> +/Module.markers
> +/Module.symvers
> +!/.gitignore
> +!/.mailmap
>  
>  #
>  # Generated include files

Actually you want to *not ignore* .gitignore and .mailmap (and
.gitattributes which is missing here) anywhere, not only as top-level
file.  So .gitignore and .mailmap should not be prepended with slash.

   #
   # Top-level generic files
   #
  -tags
  -TAGS
  -linux
  -vmlinux
  -vmlinuz
  -System.map
  -Module.markers
  -Module.symvers
  +/tags
  +/TAGS
  +/linux
  +/vmlinux
  +/vmlinuz
  +/System.map
  +/Module.markers
  +/Module.symvers
   !.gitignore
   !.mailmap


-- 
Jakub Narebski
Poland
ShadeHawk on #git
