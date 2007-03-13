Return-Path: <linux-kernel-owner+w=401wt.eu-S933103AbXCMUMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbXCMUMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbXCMUMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:12:20 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:25143 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102AbXCMUMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:12:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kW9yhnfqQJNzN7jmnR4hEdiH9ZtIbRmJjoLP38w/akbBt7a9VyBTLWYkj7E822a/bSwm2bNpv13aJiMVEL3zk0vxCAg3Qe2uCSQ5LEwQ4qS9r2lfzMwKgPEIC6WTvAPWGHk9L9pSYUSDw4wMrTwQhVW3cxYbkx4Dlnp1RPgzB7g=
Message-ID: <b637ec0b0703131312p22ee137fjc4911db07d8fa54a@mail.gmail.com>
Date: Tue, 13 Mar 2007 21:12:17 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [3/6] 2.6.21-rc3: known regressions
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Vladimir Brik" <no.hope@gmail.com>, "Andi Kleen" <ak@muc.de>,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       "Randy Dunlap" <randy.dunlap@oracle.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, "Ray Lee" <ray-lk@madrabbit.org>,
       Colchao <colchaodemola@gmail.com>,
       "=?UTF-8?Q?Mathieu_B=C3=A9rard?=" <Mathieu.Berard@crans.org>,
       "Tejun Heo" <htejun@gmail.com>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org,
       "Michal Jaegermann" <michal@ellpspace.math.ualberta.ca>,
       "Plamen Petrov" <plamen.petrov@tk.ru.acad.bg>,
       "Laurent Riffard" <laurent.riffard@free.fr>
In-Reply-To: <20070313140323.6ee03eee@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
	 <20070313125006.GT18731@stusta.de>
	 <20070313140323.6ee03eee@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Subject    : libata: PATA UDMA/100 configured as UDMA/33
> > References : http://lkml.org/lkml/2007/2/20/294
> >              http://www.mail-archive.com/linux-ide@vger.kernel.org/msg04115.html
> >              http://bugzilla.kernel.org/show_bug.cgi?id=8133
> >              http://bugzilla.kernel.org/show_bug.cgi?id=8164
> > Submitter  : Fabio Comolli <fabio.comolli@gmail.com>
> >              Plamen Petrov <plamen.petrov@tk.ru.acad.bg>
> >              Laurent Riffard <laurent.riffard@free.fr>
> > Handled-By : Tejun Heo <htejun@gmail.com>
> > Status     : patch available
>
> Some cases should be fixed now but probably not all (eg the Nvidia one)
>

This regression is still present in 2.6.21-rc3-g8b9909de (pulled from
Linus' tree less than one hour ago).

Fabio
