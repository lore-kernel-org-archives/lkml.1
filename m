Return-Path: <linux-kernel-owner+w=401wt.eu-S1762045AbYBCR7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045AbYBCR7b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 12:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756956AbYBCR7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 12:59:08 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:53660 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529AbYBCR7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 12:59:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=mSJbYYHZGmYmuDbwWYnPZ2zlGnTqsUz0QX6AxTn7OC/SMgjJYlV5WdtcDom5GFALm+EiVWASX3Dm7ZB1oUC5jKLwp2eRl+uQ5oI/SxPvAcCKkQt1N89DsaxrMEFvSdDTo5hlwxQCQpLeqDVaXXLQQwTNv3XqteaW9SsP4PTRdY0=
Date: Sun, 3 Feb 2008 23:28:55 +0530
From: Rabin Vincent <rabin@rab.in>
To: Frank Seidel <frank@f-seidel.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove unneeded code in sys_getpriority
Message-ID: <20080203175854.GB3124@ubuntu>
References: <20080203030429.GB7459@ubuntu> <200802031054.45604.frank@f-seidel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802031054.45604.frank@f-seidel.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 10:54:45AM +0100, Frank Seidel wrote:
> On Sunday 03 February 2008 04:04, Rabin Vincent wrote:
> > This check is not required because the condition is always true.
> > ...
> > -				if (niceval > retval)
> > -					retval = niceval;
> > +				retval = 20 - task_nice(p);
> 
> Thats surely correct, but on the other hand currently those
> case blocks are quite independet of their possition/could easily
> be rearranged now .. or think of another case is put ahead.
> Then this could mess up things.

Do you mean the PRIO_* cases in the switch?  They're still independent
of position after the patch because they don't fall through.

> Thanks,
> Frank

Rabin
