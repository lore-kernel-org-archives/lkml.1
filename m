Return-Path: <linux-kernel-owner+w=401wt.eu-S1751353AbZHRVsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbZHRVsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbZHRVsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:48:06 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:38184 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZHRVsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:48:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JYZbO5I/F3YPqYaEhgWgE5MSlpmy3yWo0cVHRoWcRfjH7C8gUYZOx0KjwSu1U28eJn
         fel6swFCSRE1etBQovLqukzW1Yz0Q6koAeb0pyp4tNgc/cmte+TTOYImclYZOL0J14ib
         bmurTsa+f/2HLaY3r2V6bHvXEVUKenbSAPI/g=
MIME-Version: 1.0
In-Reply-To: <20090818145801.GA32343@elte.hu>
References: <20090818145801.GA32343@elte.hu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 18 Aug 2009 17:47:46 -0400
Message-ID: <8bd0f97a0908181447i66a8571fg152868c8ec4233b5@mail.gmail.com>
Subject: Re: [PATCH] Blackfin: Fix link errors with binutils 2.19 and GCC 4.3
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 10:58, Ingo Molnar wrote:
> Not sure whether this has been reported/fixed before.
>
> Today I built a Blackfin tool-chain from scratch for -tip testing,
> and it triggers:
>
>  arch/blackfin/kernel/vmlinux.lds:1238: undefined section `.data_a_l1' referenced in expression
>
> and:
>
>  arch/blackfin/kernel/vmlinux.lds:1238: undefined section `.text_data_l1'
> referenced in expression
>
> Now i dont have any way to test this linker script, but it now at
> least builds fine after fixing what appears to be typos in those
> assert statements.

they're def typos made when i copy & pasted earlier lines.  but
binutils-2.17 apparently doesnt mind which is why i didnt notice.  ive
merged this into the Blackfin tree, thanks
-mike
