Return-Path: <linux-kernel-owner+w=401wt.eu-S1759178AbXE1DLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178AbXE1DLS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 23:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbXE1DLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 23:11:07 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:58852 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbXE1DLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 23:11:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r2o+m9Po2S6fBGwDUWrfsSwHhCSUFnvOm29fteXSVdEA2uX1uB/ayQe8GFTgoXxdeUMue96imO0LIzpIPbayEiLT9p2uxHZ/bWsv26gJ+dioQRyv5yNWXxjym9G0GCcs/b4ffbCjPLePf2QCnZAAxCBfQTGDCmDjkuP4hZshkLk=
Message-ID: <a8e1da0705272011g6ad2550eo153eb0e98590b11a@mail.gmail.com>
Date: Mon, 28 May 2007 03:11:04 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: Re: [patch -mm 1/1] remove useless tolower in isofs
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.0.99.0705272248110.6131@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0705271808w3a6dc453rfb47dd3db100718@mail.gmail.com>
	 <alpine.DEB.0.99.0705272248110.6131@sigma.j-a-k-j.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> And then there's the supercompact form.
>
> while (len--) {
>         hash = partial_name_hash(tolower(*name++), hash);
> }
>
> But I do not like the last one at all. The first one is the best, because
> it clearly separates the condition and iteration parts of the expression,
> while STILL being only three lines long. Or two, if you omit the braces.
> (But you shouldn't.)
>

IMO, I like the last one, but I prefer to keep the original author's
one, I only remove the unnecessary tolower function.
What do you think about this , Andrew?

Regards
dave
