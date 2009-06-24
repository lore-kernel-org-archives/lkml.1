Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbZFXGdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbZFXGdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbZFXGcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:32:50 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:48564 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbZFXGct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:32:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L72dw4c2RxQ9GQAa4S/GcCejObaQq9Xw2hFCehnN1cmljSBIGK3nYUlxxmlDxUfHzX
         eHFQLLfS3emsuFV2Rh4MhWAsXxM2eDLobaCTqIM+UnkLfw+jF061jc5hqoR7UY64BhnQ
         UPogJWvaAguFsWErHiz6kkwIeCbVul6/1F+Ps=
MIME-Version: 1.0
In-Reply-To: <200906232355.34134.arnd@arndb.de>
References: <4A33A7EC.6070008@gmail.com> <20090623192648.GB23119@logfs.org>
	 <1245791743.25547.3517.camel@macbook.infradead.org>
	 <200906232355.34134.arnd@arndb.de>
Date: Wed, 24 Jun 2009 08:32:50 +0200
Message-ID: <2ea1731b0906232332n2488d452p27419eac7edab7e4@mail.gmail.com>
Subject: Re: [PATCH 06/14] Pramfs: Include files
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Woodhouse <dwmw2@infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Sam Ravnborg <sam@ravnborg.org>, Tim Bird <tim.bird@am.sony.com>,
       Chris Simmonds <chris@2net.co.uk>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/23 Arnd Bergmann <arnd@arndb.de>:
> On Tuesday 23 June 2009, David Woodhouse wrote:
>> And dd on /dev/mem would work, surely?
>
> Actually, reading from /dev/mem is only valid on real RAM. If the nvram
> is part of an IO memory mapping, you have to do mmap()+memcpy() rather
> than read(). So dd won't do it, but it's still easy to read from user
> space.

For "security" reasons pram reserve the region of memory with
reserve_mem_region_exclusive().....

>
>> I'd definitely recommend making it fixed-endian. Not doing so for JFFS2
>> was a mistake I frequently regretted.
>
> Right.
>
>        Arnd <><
>
