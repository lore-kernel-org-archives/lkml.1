Return-Path: <linux-kernel-owner+w=401wt.eu-S1765817AbXGWXNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765817AbXGWXNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbXGWXNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:13:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:16732 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbXGWXNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:13:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oxf1LFKM0N2kuV8QOrLZJiAG7pLAQb94K2YXG5GE1cxI2uYNAZjFjqbf+GtiO0O8cXjI+LAwwW0mZDX+bTPM4mWX4pVNOc0jqMSIJ+UeWYyaXkD1JAbvhAH/T91oBXxBJcZXxyB1LhpOnZZT23CNTPxTAFM7ITUD/mHOyj08/6Q=
Message-ID: <9a8748490707231613h4a459651x316b111447df94bb@mail.gmail.com>
Date: Tue, 24 Jul 2007 01:13:11 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
Cc: "Andrew Morton" <akpm@osdl.org>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Joel Schopp" <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <740c90243aaa6f6d4640d71230c4fa27@pinky>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <740c90243aaa6f6d4640d71230c4fa27@pinky>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/07, Andy Whitcroft <apw@shadowen.org> wrote:
>
> This version brings a number of new checks, and a number of bug
> fixes.  Of note:
>
>   - warnings for multiple assignments per line
>   - warnings for multiple declarations per line
>   - checks for single statement blocks with braces
>
> This patch includes an update for feature-removal-schedule.txt to
> better target checks.
>
> Andy Whitcroft (12):
>       Version: 0.08
>       only apply printk checks where there is a string literal
>       allow suppression of errors for when no patch is found
>       warn about multiple assignments
>       warn on declaration of multiple variables
>       check for kfree() with needless null check

It's not just kfree(), it's a whole list of functions, like kfree(),
vfree(), crypto_free_tfm() and a bunch of other freeing functions...


>       check for single statement braced blocks

Hmmm, if the single statement is a macro, braces sometimes make a lot
of sense...


Suggested further improvement; check that patches don't modify files
listed in Documentation/dontdiff


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
