Return-Path: <linux-kernel-owner+w=401wt.eu-S1751389AbZL2TkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbZL2TkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 14:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbZL2TkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 14:40:11 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:48489 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZL2TkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 14:40:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QX5ufVV14kcW/Rf5rq0MTXlIDBHW6KXDSf2jRumo4qDTlGe4IjrXRQAj9MTak5tGdi
         QEciJFM2hxdT4AC2utV3TtLO5iYdKjtq9lhqk6daQCJ2z53E9J6c2Gn5no/2ZVSJXGje
         MBO3DXJ4czF+3j3nSyd5Oe9iZ2df9l7S/jRGU=
Message-ID: <4B3A5B15.5060807@garzik.org>
Date: Tue, 29 Dec 2009 14:40:05 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what's the purpose of MAXHOSTNAMELEN?
References: <alpine.LFD.2.00.0912291416230.4967@localhost>
In-Reply-To: <alpine.LFD.2.00.0912291416230.4967@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2009 02:19 PM, Robert P. J. Day wrote:
>
>    in prepping for coalescing a lot of param.h files, i'm curious about
> the purpose of this macro:
>
> $ grep -rw MAXHOSTNAMELEN *
> arch/s390/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
> arch/sparc/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
> arch/alpha/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
> arch/mn10300/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
> arch/arm/include/asm/param.h:#define MAXHOSTNAMELEN  64
> arch/m32r/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
> arch/mips/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
> arch/m68k/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
> arch/xtensa/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
> arch/ia64/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
> arch/h8300/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
> arch/avr32/include/asm/param.h:#define MAXHOSTNAMELEN	64
> arch/cris/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
> arch/um/include/asm/param.h:#define MAXHOSTNAMELEN  64      /* max length of hostname */
> arch/powerpc/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
> arch/parisc/include/asm/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
> arch/frv/include/asm/param.h:#define MAXHOSTNAMELEN		64	/* max length of hostname */
> include/asm-generic/param.h:#define MAXHOSTNAMELEN	64	/* max length of hostname */
> include/net/sctp/structs.h:#include<asm/param.h>		/* We get MAXHOSTNAMELEN.     */
> $
>
>    so lots of people define it but no one uses it.  it *is* exported to
> user space in /usr/include/asm/param.h, but i still have no idea what
> it's for in user space.  obsolete?

According to RFC 1034, "Each node has a label, which is zero to 63 
octets in length"

What is it used for in userspace, and why is it export from the kernel? 
  Good question...

	Jeff



