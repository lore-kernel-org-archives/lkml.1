Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbXFYSA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbXFYSA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 14:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbXFYSAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 14:00:21 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:29375 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbXFYSAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 14:00:21 -0400
Date: Mon, 25 Jun 2007 11:01:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ioannis Barkas <risc4all@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VGA-softcursor.txt: Point at the correct directory of
 vgacon.c
Message-Id: <20070625110103.b60bf330.randy.dunlap@oracle.com>
In-Reply-To: <126518.4255.qm@web63510.mail.re1.yahoo.com>
References: <126518.4255.qm@web63510.mail.re1.yahoo.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007 10:47:21 -0700 (PDT) Ioannis Barkas wrote:

> Fixes wrong, outdated path of vgacon.c
> 
> Hello we are Ioannis Barkas (risc4all@yahoo.com) and
> Nikos Barkas (doubl3nuts@yahoo.com).
> 
> VGA-softcursor.txt points to vgacon.c at a wrong
> directory so we fix it.
> 
> There is the patch(we do not attach it as many people
> suggest not to do so) from diff -u:

That didn't work so well.  Looks like yahoo mail is splitting
the patch lines at places that you didn't intend, so the
patch cannot be applied by 'patch':  'patch' says that the
patch is malformed.

You will need to continue to use attachments (yes, we prefer
inline patches instead of attachments) or you will need to
configure yahoo mail so that it doesn't muck up your inline
patches (I don't know if this is possible) or you will need
to use a different (and decent) mail client.  When you are
ready to try again, please send the patch to yourself first
and make sure that the received email patch can be applied
cleanly.


> --- /linux-2.6.21/Documentation/VGA-softcursor.txt
> 2007-04-26 04:08:32.000000000 -0400
> +++ /linux/Documentation/VGA-softcursor.txt	2007-06-25
> 02:21:23.000000000 -0400
> @@ -4,11 +4,11 @@
>     Linux now has some ability to manipulate cursor
> appearance. Normally, you
>  can set the size of hardware cursor (and also work
> around some ugly bugs in
>  those miserable Trident cards--see #define
> TRIDENT_GLITCH in drivers/video/
> -vgacon.c). You can now play a few new tricks:  you
> can make your cursor look
> -like a non-blinking red block, make it inverse
> background of the character it's
> -over or to highlight that character and still choose
> whether the original
> -hardware cursor should remain visible or not.  There
> may be other things I have
> -never thought of.
> +console/vgacon.c). You can now play a few new tricks:
>  you can make your
> +cursor look like a non-blinking red block, make it
> inverse background of the
> +character it's over or to highlight that character
> and still choose whether
> +the original hardware cursor should remain visible or
> not.  There may be other
> +things I have never thought of.
>  
>     The cursor appearance is controlled by a
> "<ESC>[?1;2;3c" escape sequence
>  where 1, 2 and 3 are parameters described below. If
> you omit any of them,


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
