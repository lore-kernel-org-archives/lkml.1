Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbZHFCAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbZHFCAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 22:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZHFCAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 22:00:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753695AbZHFCAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 22:00:20 -0400
Date: Wed, 5 Aug 2009 18:59:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: <joe@perches.com>, <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <mcgrof@gmail.com>
Subject: Re: [PATCH 3/3] checkincludes.pl: add option to remove duplicates
 in place
Message-Id: <20090805185945.1ece6088.akpm@linux-foundation.org>
In-Reply-To: <1249519872-23958-4-git-send-email-lrodriguez@atheros.com>
References: <1249519872-23958-1-git-send-email-lrodriguez@atheros.com>
	<1249519872-23958-4-git-send-email-lrodriguez@atheros.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Aug 2009 17:51:12 -0700 "Luis R. Rodriguez" <lrodriguez@Atheros.com> wrote:

> checkincludes.pl is more useful if it actually removed
> the lines. This adds support for that with -r.
> 

hm, spose so.  It can't do any harm.

Plus it's about time we edited that file - it hasn't been changed since
we started the bk tree.


> ---
>  scripts/checkincludes.pl |   57 +++++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 51 insertions(+), 6 deletions(-)
> 
> diff --git a/scripts/checkincludes.pl b/scripts/checkincludes.pl
> index 4bff139..5a53407 100755
> --- a/scripts/checkincludes.pl
> +++ b/scripts/checkincludes.pl
> @@ -2,32 +2,77 @@
>  #
>  # checkincludes: Find files included more than once in (other) files.
>  # Copyright abandoned, 2000, Niels Kristian Bech Jensen <nkbj@image.dk>.
> +# Copyright abandoned, 2009, Luis R. Rodriguez <mcgrof@gmail.com>
>  
>  sub usage {
> -	print "Usage: checkincludes.pl <file list>\n";
> +	print "Usage: checkincludes.pl [-r]\n";
> +	print "By default we just warn of duplicates\n";
> +	print "To remove files in place use -r\n";

I'm not sure I like the wording here - I don't _want_ my files removed!

This?

--- a/scripts/checkincludes.pl~checkincludespl-add-option-to-remove-duplicates-in-place-fix
+++ a/scripts/checkincludes.pl
@@ -7,7 +7,7 @@
 sub usage {
 	print "Usage: checkincludes.pl [-r]\n";
 	print "By default we just warn of duplicates\n";
-	print "To remove files in place use -r\n";
+	print "To remove duplicated includes in place use -r\n";
 	exit 1;
 }
 
_

