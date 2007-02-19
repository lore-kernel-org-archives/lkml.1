Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbXBSAa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbXBSAa5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 19:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbXBSAa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 19:30:57 -0500
Received: from terminus.zytor.com ([192.83.249.54]:42873 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbXBSAa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 19:30:56 -0500
Message-ID: <45D8EFB8.4050805@zytor.com>
Date: Sun, 18 Feb 2007 16:30:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: memparse(), simple_strtoul() prototypes...
References: <38b2ab8a0702180804l26d99a01y558bce2ee964d973@mail.gmail.com>
In-Reply-To: <38b2ab8a0702180804l26d99a01y558bce2ee964d973@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau wrote:
> Hi,
> 
> I must miss something...
> 
> Looking at these prototypes
> 
> unsigned long simple_strtoul(const char *cp, char **endp,unsigned int base)
> unsigned long long memparse (char *ptr, char **retptr)
> 
> I'm really wondering why not all parameters are not all 'const'. None
> of these functions modify any pointer containts. And simple_strtoul()
> ends up doing sometghing like:
> 
> if (endp)
>         *endp = (char *)cp;
> 
> Could anyone shed some light ?

The C standard behaves like that, too, mostly because C doesn't have a 
way to say "X is const iff Y is const" (unlike C++, btw.)

	-hpa
