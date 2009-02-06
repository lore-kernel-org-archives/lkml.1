Return-Path: <linux-kernel-owner+w=401wt.eu-S1757726AbZBFSvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbZBFSvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbZBFSvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:51:00 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:31976 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbZBFSu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:50:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wyv0I4TFrxspTD+Y+rB0coPDOFm8RXWWed4DbFovIV+paT0ne++dp5v94gMcXPTmlf
         rYhYHJefZnlD1r3UuDvClsYCPH3lwTRNdSDjrXMr31PNVtcdD84FawtPIeYaEW6a8A5w
         F0Q6tBtJarSgZBFvpiuyAr55m5JbBc8iS64BQ=
MIME-Version: 1.0
In-Reply-To: <6bd94bae0902061008n251d6bb9g9b9ec5bc791dc9ae@mail.gmail.com>
References: <6bd94bae0901310536l2cd42fa1off60ee066fa0096b@mail.gmail.com>
	 <20090131134651.GC28763@khazad-dum.debian.net>
	 <6bd94bae0901310604u6ed876f1n77b7e2561f479ad1@mail.gmail.com>
	 <6bd94bae0901310651k6a85e2a8g280308da272bdaf7@mail.gmail.com>
	 <20090201014453.GC22841@khazad-dum.debian.net>
	 <6bd94bae0902061008n251d6bb9g9b9ec5bc791dc9ae@mail.gmail.com>
Date: Fri, 6 Feb 2009 10:50:58 -0800
X-Google-Sender-Auth: e20d967a4ac76a43
Message-ID: <2c0942db0902061050u4a854958u7e7a2db60e67baa6@mail.gmail.com>
Subject: Re: Spurious Filesystem corruption with ext3 + large (<400GB) hw RAID 
	partition + SMP
From: Ray Lee <ray-lk@madrabbit.org>
To: Manfred Wassmann <tux.wassmann@googlemail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 6, 2009 at 10:08 AM, Manfred Wassmann
<tux.wassmann@googlemail.com> wrote:
> On 2/1/09, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> [...]
>> Search the list archives, there are other problem reports for that
>> 3ware card, you probably want to check those.
>
> Thank you very much, I checked these but I could not find much about
> filesystem corruption problems. The most similar problem was mentioned
> in http://lkml.org/lkml/2008/6/23/230 but was related to xen which
> isn't in use here.
>
> Regarding the memory test, memtest86+ ran for almost 70 hours without
> detecting any error.
>
> I trying to reproduce the problem using my installation disk and
> running stress/dbench but wasn't able to do so. The only reliable way
> to reproduce it is to install Ubuntu, which isn't very helpful :-(

Huh. It may be related to whatever kernel version Ubuntu uses to boot
up the install media. Try a different version of Ubuntu (older, newer
if a newer one exists) to see if it has the same problem.
