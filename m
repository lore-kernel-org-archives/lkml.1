Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbZALSGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbZALSGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZALSGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:06:02 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:27784 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZALSGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:06:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=waugLvXPwHyISkbdKVLoI4UVXkQdMvM4A5BsqvpR3byhbmEs8A2+kNEdIr3FKnhWne
         fuZwukRcfCAr0hWmUbP6nutmHeULteoaCuJg59uJEEX5UbrVFNYJgNpxpb/J/J9CeUvR
         ctIS2B+cSx8d59o+imivYskAUKK9HYisSvKU8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 2/9] sl82c105: remove dead code
Date: Mon, 12 Jan 2009 18:59:47 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-next-20090107; KDE/4.1.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linuxppc-dev list" <Linuxppc-dev@ozlabs.org>
References: <20090106183520.21193.63704.sendpatchset@localhost.localdomain> <20090106183526.21193.24866.sendpatchset@localhost.localdomain> <496A613F.5090901@ru.mvista.com>
In-Reply-To: <496A613F.5090901@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901121859.48001.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 January 2009, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> > CONFIG_LOPEC and CONFIG_SANDPOINT config options are gone.
> >   
> 
>   So these are gone with arch/ppc/?

Yep.

>   That's a pity -- MV has spent a lot of efforts on porting the latter 
> to arch/powerpc/ but somehow it haven't got merged upstream. My patches 
> ot this driver were actually due to it being used on Sandpoint. :-)

Heh, and I cleaned ppc IDE hooks just before these platforms were removed
(that's how these ifdefs got into sl82c105.c). :-)

Thanks,
Bart
