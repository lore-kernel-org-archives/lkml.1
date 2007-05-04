Return-Path: <linux-kernel-owner+w=401wt.eu-S1161889AbXEDTG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161889AbXEDTG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161888AbXEDTG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:06:26 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:37795 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031498AbXEDTGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:06:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VNuY0UJfmDLTXFBKQcc0yC+YP0xqcNJwgx7zl6MtKXkkaDqPJMn2MWyLsDK4jl7tLcXZ1sVZc9z26geRfdjvPCsCbkFIV65+MDoJW6v5qMvRz3hZnLuQorDfim6Zfqd2fo3lUb8L7xxp1clYFP0G2sA3AlNPKXe4LjiDJ6GG7Gc=
Message-ID: <5486cca80705041206q3a077dedyedb5ac2fbf434ba8@mail.gmail.com>
Date: Fri, 4 May 2007 21:06:23 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Paul Fulghum" <paulkf@microgate.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <5486cca80705041146x5c5bda70s96ce74e389cc1635@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <1178290160.3913.2.camel@amdx2.microgate.com>
	 <5486cca80705040904v786f13dh5614174fcc51c202@mail.gmail.com>
	 <5486cca80705040956g47f634ddp80d67038e8e3305a@mail.gmail.com>
	 <463B7534.6000207@microgate.com>
	 <5486cca80705041013pf481c2an9e639fc9285ba88e@mail.gmail.com>
	 <1178299247.3769.0.camel@amdx2.microgate.com>
	 <5486cca80705041025k46ccf716t8dcd1e6f29e2376e@mail.gmail.com>
	 <1178300493.3619.1.camel@amdx2.microgate.com>
	 <5486cca80705041146x5c5bda70s96ce74e389cc1635@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/07, Antonino Ingargiola <tritemio@gmail.com> wrote:
[cut]
> I'm quite confident the system blocks on "Setting consoles fonts and
> modes.", and thus during the boot script console-screen.h. I'll try to
> see which commands blocks...

Filling with echo console-screen.sh I've found that the blocking command is:

    unicode_start 2> /dev/null || true

or at least the echo before this command is the last shown.

Regards,

  ~ Antonio
