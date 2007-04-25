Return-Path: <linux-kernel-owner+w=401wt.eu-S1031042AbXDYPMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031042AbXDYPMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031038AbXDYPMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:12:44 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:29928 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030996AbXDYPMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:12:43 -0400
Date: Wed, 25 Apr 2007 08:15:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, oliver@neukum.org,
       oneukum@suse.de, tilman@imap.cc
Subject: Re: + codingstyle-start-flamewar-about-use-of-braces.patch added to
 -mm tree
Message-Id: <20070425081525.9e9b1e57.randy.dunlap@oracle.com>
In-Reply-To: <200704201802.l3KI2Nlh020621@shell0.pdx.osdl.net>
References: <200704201802.l3KI2Nlh020621@shell0.pdx.osdl.net>
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

On Fri, 20 Apr 2007 11:02:23 -0700 akpm@linux-foundation.org wrote:

> 
> The patch titled
>      CodingStyle: start flamewar about use of braces
> has been added to the -mm tree.  Its filename is
>      codingstyle-start-flamewar-about-use-of-braces.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: CodingStyle: start flamewar about use of braces
> From: Oliver Neukum <oliver@neukum.org>
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.de>
> Cc: Tilman Schmidt <tilman@imap.cc>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Was this on lkml?  I couldn't find it anywhere.

I won't add an ack to it.  No flames.


>  Documentation/CodingStyle |   15 +++++++++++++++
>  1 files changed, 15 insertions(+)
> 
> diff -puN Documentation/CodingStyle~codingstyle-start-flamewar-about-use-of-braces Documentation/CodingStyle
> --- a/Documentation/CodingStyle~codingstyle-start-flamewar-about-use-of-braces
> +++ a/Documentation/CodingStyle
> @@ -160,6 +160,21 @@ supply of new-lines on your screen is no
>  25-line terminal screens here), you have more empty lines to put
>  comments on.
>  
> +Do not unnecessarily use braces where a single statement will do.
> +
> +if (condition)
> +	action();
> +
> +This does not apply if one branch of a conditional statement is a single
> +statement. Use braces in both branches.
> +
> +if (condition) {
> +	do_this();
> +	do_that();
> +} else {
> +	otherwise();
> +}
> +
>  		3.1:  Spaces
>  
>  Linux kernel style for use of spaces depends (mostly) on


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
