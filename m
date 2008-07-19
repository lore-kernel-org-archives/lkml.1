Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbYGSOIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbYGSOIM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 10:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYGSOH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 10:07:57 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:53382 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbYGSOH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 10:07:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=muXMNPdcI9UHuRKEXoLkjsds3YtKRzFyhJgBOEprnyAQ+zN+Q383QI70dnnek9m0+C
         /7SNG4B1rDcLwBLgeWZefpJvFVRRoTu3tt0WlX3dlKp8NkWO84vGTdIuNRy6ryNyu8UL
         V5IrtrII8TZl7BtYjyn5/xuJCN8CpWlJe4UUM=
Message-ID: <19f34abd0807190707q296ef898xa0235186cc628edc@mail.gmail.com>
Date: Sat, 19 Jul 2008 16:07:55 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH 0/3] acpi: GPE fixes
Cc: "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4881D205.1000901@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <487D23C3.5070301@student.cs.york.ac.uk> <487F31D7.30803@suse.de>
	 <20080717121309.GF31732@khazad-dum.debian.net>
	 <487F3B6D.3090507@suse.de>
	 <20080717162628.GB18457@khazad-dum.debian.net>
	 <487F7724.5080905@tuffmail.co.uk>
	 <20080717185032.GD18457@khazad-dum.debian.net>
	 <487F986A.3070504@tuffmail.co.uk> <4881D205.1000901@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 1:37 PM, Alan Jenkins
<alan-jenkins@tuffmail.co.uk> wrote:
> Here's what I came up with -
>
> 1.  I was fighting against EC_FLAGS_QUERY_PENDING.  This was used to ignore
>    multiple successive GPE interrupts and treat them as a single GPE instead.
>    That's the exact opposite of what we want to do.  Let's get rid of it.
>
> 2.  Then we can apply my original patch to fix GPE polling on the Asus EeePC,
>    by repeatedly querying for GPEs until there are none left.
>
> 3.  Finally, if I'm right then we now know how to handle "GPE interrupt storms".
>    Some EC's are raising multiple interrupts before we acknowledge them. but
>    they're just telling us how many events are pending.  There's no harm in
>    that, so we don't ever need to disable GPE interrupts.  Let's get rid of
>    GPE polling mode.  (Code mainly stolen from Alexey).

Hi,

I have seen the "GPE storm" message before but it had no apparent
side-effects. Your patches do not seem to change this, although the
message is now gone. Thanks! (I have an Acer Aspire 5720 laptop.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
