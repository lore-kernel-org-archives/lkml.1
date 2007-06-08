Return-Path: <linux-kernel-owner+w=401wt.eu-S937399AbXFHEmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937399AbXFHEmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 00:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbXFHEmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 00:42:10 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:31905 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbXFHEmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 00:42:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=GONmuYOlIbRuMJ/xENGBUFJIAqIo3B9DZgfGiTJfks9ICjJVcqcK375mZpS84GAtjGSkUpeOfJNcLI+pbzfj1j+AGF3mOQ+dU1Xv4LPpssNOpxe1bwPQgbpUv4R/x339TKlXO1Uvamih44bQPj+1XGCl70AljAzvAgAJhktcrK8=
Date: Fri, 8 Jun 2007 12:43:01 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070608044301.GA2822@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070606161936.GA8952@localhost.localdomain> <20070606110931.fda845de.akpm@linux-foundation.org> <20070607022608.GA2416@localhost.localdomain> <20070607055912.GX11166@waste.org> <20070607065158.GA1996@localhost.localdomain> <20070607140444.GR11115@waste.org> <20070607154007.GA9305@localhost.localdomain> <20070607155913.GW11115@waste.org> <20070607163930.GA11060@localhost.localdomain> <20070607165916.GZ11115@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607165916.GZ11115@waste.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 11:59:16AM -0500, Matt Mackall wrote:
>On Fri, Jun 08, 2007 at 12:39:30AM +0800, WANG Cong wrote:
>> >Ketchup doesn't even look inside patches, and patch doesn't invent
>> >names, so something in the bzip2 -> patch(1) -> filesystem chain got
>> >corrupted. Probably not bzip2, as it has CRCs.
>> >
>> 
>> Do you mean ketchup doesn't do anything if a file is corrupted?
>
>Ketchup never even sees the filenames. It just calls bzip2 | patch. So
>it can't be responsible for damaging the filename.
> 
>> >Do you have ECC memory?
>>
>> No. Do you mean it's an error of my RAM? I have never met such things before,
>> how often does such kind of things happen? May be less often than a bug in
>> a stable kernel?
>
>The best studies I've seen suggest so-called "soft errors" in DRAM
>happen at a rate of once a week to once a day per gigabyte of RAM at
>sea-level. It's unknown how many of these errors manifest by visibly
>corrupting data, but it wouldn't be surprising if it were
>significantly less than 10%. But ECC is definitely not just for the
>paranoid!
>
>So if I were to rank the reliability of everything, it'd look
>something like this, highest to lowest:
>
> bzip: simple, stable and heavily-used codebase, built-in safeguards like CRC
> patch: simple, stable, heavily-used, limited detection of input errors
> CPU: heavily used, very low non-catastrophic failure rate
> disk: heavily used, CRC on cable, ECC on disk
> kernel: complex, rapidly-changing, but heavily-used
> Non-ECC DRAM: significant known transient failure rate
> 
>When the error rate for the kernel approaches that of DRAM, it gets
>very hard to assign blame.
>
>(And of course, there's the user, who tends to be near the bottom of
>this range, but I'll let you judge that.)

Good explanation! Thanks!

That the RAM error occurs so often really surprises me.
I think it might be RAM's fault, because, at least, it's less reproduceable than
a bug in a stable kernel.


Regards!

