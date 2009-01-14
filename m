Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbZANVUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbZANVUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbZANVUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:20:24 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:64592 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937AbZANVUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:20:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Spp9U2iUvWWVTtY53Mow0St3BT/C3xy/PY4j7o1iF1iyybFKOZHpN6qgqIF7cdX740
         vu9uwVjf3ERgNQi7pIOR7+aDq1GH9mgA/1W8rDfRHiL0wyBeCxRpRd6hA1PFMhYE3NKR
         84rfVO5XsCNQ7qVR/Rg670pnTRiaQyePAoyvw=
Date: Thu, 15 Jan 2009 00:20:18 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>, mingo@elte.hu, hpa@zytor.com,
       linux-kernel@vger.kernel.org, sam@ravnborg.org,
       jaswinderrajput@gmail.com
Subject: Re: [patch 1/5] x86: headers cleanup - boot.h
Message-ID: <20090114212018.GF8178@localhost>
References: <20090114203745.285473388@gmail.com> <496e4e23.1358560a.0b42.ffff8588@mx.google.com> <1231967080.5756.12.camel@brick> <20090114211142.GE8178@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114211142.GE8178@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Thu, Jan 15, 2009 at 12:11:42AM +0300]
| [Harvey Harrison - Wed, Jan 14, 2009 at 01:04:40PM -0800]
| | On Wed, 2009-01-14 at 23:37 +0300, Cyrill Gorcunov wrote:
| | > -#if (defined CONFIG_KERNEL_BZIP2)
| | > +#ifdef CONFIG_KERNEL_BZIP2
| | >  #define BOOT_HEAP_SIZE             0x400000
| | > -#else
| | > +#else /* !CONFIG_KERNEL_BZIP2 */
| | 
| | Curious, I haven't seen the #else comments with the extra ! before,
| | is that something that's coming into common use?
| | 
| | Harvey
| | 
| 
| Actually I saw the both.
| 
| ./arch/mips/include/asm/dec/prom.h:54:#else /* !CONFIG_64BIT */
| ./arch/mips/include/asm/dec/prom.h:58:#endif /* !CONFIG_64BIT */
| 
| 		- Cyrill -

You know Harvey, I think such a details could be
mentioned in CodingStyle. At least I found two
types of comments:

1) Forward comments:

	#if FOO
	#else	/* !FOO */
	#endif	/* !FOO */

2) Backward comments:

	#if FOO
	#else	/* FOO */
	#endif	/* !FOO */

I prefer the first variant. But with any variant
I'm always rereading twice what is defined and
what is not :)

		- Cyrill -
