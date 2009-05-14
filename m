Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbZENFEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbZENFEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 01:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZENFEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 01:04:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:63726 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbZENFEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 01:04:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vBBvJ55JKEshZWxdCBITi49TUB5eHsRXI9MD6QJVkROtm3qjl9eiBRa7AEsyvHf2rz
         3Q9OnXqfpu3pOGR/Uj7jPQQ7oPUmZzBDaS3VEXuLgWIijYAzzhKJ3HvEPJqEftJxNGDE
         CROc+sMlePBQunAd2FckZp8X/vnUpmmK2SX6Q=
Subject: Re: Specific support for Intel Atom architecture
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <a36005b50905121045s62c16760p3aba003647a572c7@mail.gmail.com>
References: <200904301408.09370.tobias.doerffel@gmail.com>
	 <877i0xib7d.fsf@basil.nowhere.org>
	 <a36005b50905120720p14e0ea0av79f99551262a920a@mail.gmail.com>
	 <20090512150408.GH19296@one.firstfloor.org>
	 <a36005b50905121045s62c16760p3aba003647a572c7@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 13 May 2009 22:04:13 -0700
Message-Id: <1242277453.23058.35.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 10:45 -0700, Ulrich Drepper wrote:
> On Tue, May 12, 2009 at 8:04 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > The problem is that you can't express the situations where
> > movbe is better than bswap (you need both and the old and the new
> > value) in inline assembler in a way that gcc decides automatically.
> 
> True.  But I was mostly thinking about loads from memory.  A quick
> search for ntoh*/hton* shows code like
> 
>         u_int16_t queue_num = ntohs(nfmsg->res_id);
> 
> If there would be a ntohs_load() macro movbe could be used.

It's called be16_to_cpup, or on x86, swab16p()


Cheers,

Harvey

