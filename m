Return-Path: <linux-kernel-owner+w=401wt.eu-S933769AbXCKPrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769AbXCKPrx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 11:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933782AbXCKPrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 11:47:53 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:53804 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933769AbXCKPrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 11:47:52 -0400
Date: Sun, 11 Mar 2007 09:47:43 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Style Question
In-reply-to: <fa.Da+t1e9MgP7HaKS+dOWXVD8aYNI@ifi.uio.no>
To: Cong WANG <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <45F4249F.2080501@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Da+t1e9MgP7HaKS+dOWXVD8aYNI@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cong WANG wrote:
> Hi, list!
> 
> I have a question about coding style in linux kernel. In
> Documention/CodingStyle, it is said that "Linux style for comments is
> the C89 "/* ... */" style. Don't use C99-style "// ..." comments."
> _But_ I see a lot of '//' style comments in current kernel code.
> 
> Which is wrong? The documentions or the code, or neither? And why?

The code.. As with a lot of coding style issues, it's likely just that 
nobody saw it and bothered to complain when it went in.

> Another question is about NULL. AFAIK, in user space, using NULL is
> better than directly using 0 in C. In kernel, I know it used its own
> NULL, which may be defined as ((void*)0), but it's _still_ different
> from raw zero. So can I say using NULL is better than 0 in kernel?

It's the preferred style, Sparse will complain about using 0 for a null 
pointer for example..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

