Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab0CHIll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 03:41:41 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34993 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab0CHIlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 03:41:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hG+mXxNnKJb4zHhfwJRKO8uCcSnINY/xhAjuoTy5qZ25FDJ6EXnYedNAnyr/tGiLXT
         QEfFO77wRNWkaqf0NPMnvPbwDKXlfojuYptmgshxryEK6vLVHYzqaE5ra7FPqWbDBrRb
         A/hscAdxtRIIONYvlULsxveC6ty2DUjAXW26Q=
Date: Mon, 8 Mar 2010 00:36:06 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Allie Xiong <axiong@synaptics.com>,
       William Manson <WManson@synaptics.com>
Subject: Re: [RFC PATCH 1/1] input/touchscreen: Synaptics Touchscreen Driver
Message-ID: <20100308083605.GC14856@core.coreip.homeip.net>
References: <1266446258-16209-1-git-send-email-cheiny@synaptics.com>
 <1266446258-16209-3-git-send-email-cheiny@synaptics.com>
 <20100302091246.GA21014@core.coreip.homeip.net>
 <4B905B59.8020209@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B905B59.8020209@synaptics.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 05:16:09PM -0800, Christopher Heiny wrote:
> On 03/02/2010 01:12 AM, Dmitry Torokhov wrote:
> >Hi Christofer,
> >
> >I assume that since you sent it with git-send-email it was your
> >corporate mail server that murdered all identation and whitespace.
> >Please try sending next version using alternative server, like gmail or
> >maybe your personal account. On the off chance that the formatting used
> >in the driver was preserved intact - please remember that kernel uses
> >hard tabs for identation (8 chars, no expanding). Camel-casing is also
> >frowned upon.
> 
> Actually, the strange indenting/whitespace is due to a day-long struggle
> with checkpatch.pl to get it to accept something - anything - without
> complaining.  Personally I thought the formatting that checkpatch
> finally accepted was kind of strange, but went with it.
> 
> We'll update to 8-space hard tabs only, and ignore any future
> checkpatch complaints in that department.

Umm, generally speaking checkpatch is "telling the truth" and if you run
it aginst most of the krenle code you shold get very few complaints. The
only thing I tend to ignore is the 80 column limit (which I think is
being liften in recent version).

Also, while you are at it - consider using dev_xxx() for printing
messages when you have 'struct device *' available and pr_xxx() when you
do not have it instead of using "naked" printks.

Thanks.

-- 
Dmitry
