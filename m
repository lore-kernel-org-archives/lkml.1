Return-Path: <linux-kernel-owner+w=401wt.eu-S1761302AbZBFSLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761302AbZBFSLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbZBFSIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:08:36 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:40287 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760806AbZBFSIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:08:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=LiaLQL5Rzvuck7QkfYW5afcSecaR/qQxf0FxHyydpL2KiRWegWlN7ylUKYcorYRsgs
         Rq3LrvuyEALa9IIj3YYYH744ugId/USbjGZybHa4gYtGXLaUKk+EtrT/Xqid6V8jkRxK
         FZBFxpol4VL2tpNn1bnuS/noVBtNBjaBQ9cyA=
MIME-Version: 1.0
In-Reply-To: <20090201014453.GC22841@khazad-dum.debian.net>
References: <6bd94bae0901310536l2cd42fa1off60ee066fa0096b@mail.gmail.com>
	 <20090131134651.GC28763@khazad-dum.debian.net>
	 <6bd94bae0901310604u6ed876f1n77b7e2561f479ad1@mail.gmail.com>
	 <6bd94bae0901310651k6a85e2a8g280308da272bdaf7@mail.gmail.com>
	 <20090201014453.GC22841@khazad-dum.debian.net>
Date: Fri, 6 Feb 2009 19:08:33 +0100
Message-ID: <6bd94bae0902061008n251d6bb9g9b9ec5bc791dc9ae@mail.gmail.com>
Subject: Re: Spurious Filesystem corruption with ext3 + large (<400GB) hw RAID 
	partition + SMP
From: Manfred Wassmann <tux.wassmann@googlemail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/09, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
[...]
> Search the list archives, there are other problem reports for that
> 3ware card, you probably want to check those.

Thank you very much, I checked these but I could not find much about
filesystem corruption problems. The most similar problem was mentioned
in http://lkml.org/lkml/2008/6/23/230 but was related to xen which
isn't in use here.

Regarding the memory test, memtest86+ ran for almost 70 hours without
detecting any error.

I trying to reproduce the problem using my installation disk and
running stress/dbench but wasn't able to do so. The only reliable way
to reproduce it is to install Ubuntu, which isn't very helpful :-(

As already said I'm no longer using ext3 for the systems in question,
so if switching filesystems really does solve my problem, this will be
my last post in this regard. In any case thanks for your  help.

regards Manfred
-- 
Unix "Birthday" on 2009-02-13 23:31:30 UTC
...it's 1234567890 seconds since the epoch.
