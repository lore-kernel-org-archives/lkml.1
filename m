Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab0CJICK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 03:02:10 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33148 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0CJICI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 03:02:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RvyEtbzOAf6bAunrKTnbDqvvz6P5J5TCBG4KrYIVcLeqMz2PGJxtM5WzWGcKL8cm1P
         9SgL2NnMvJn+RZ71Nh+QJOilr7WcMI/erlHjx2VGkCSU5tck0wLwqrjKYtRBZSK1JuXY
         f8VyBZH2T53erCGKnpDNtzBcEcJa6CWZe3Zh4=
MIME-Version: 1.0
In-Reply-To: <21eaeb5a1003091808s2d7638cxd524952a7d84b378@mail.gmail.com>
References: <4B968834.3040609@gmail.com>
	 <21eaeb5a1003091808s2d7638cxd524952a7d84b378@mail.gmail.com>
Date: Wed, 10 Mar 2010 09:02:06 +0100
Message-ID: <2ea1731b1003100002w104633ffy1ae46ef3d245e5b5@mail.gmail.com>
Subject: Re: [PATCH v2] char drivers: Ram oops/panic logger
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Yuasa Yoichi <yuasa@linux-mips.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/10 Yuasa Yoichi <yuasa@linux-mips.org>:
> Hi,
>
> 2010/3/10 Marco Stornelli <marco.stornelli@gmail.com>:
>> Ramoops, like mtdoops, can log oops/panic information but in RAM.
>
> What is different from mtdoops + mtd-ram?
>
> Yoichi
>

It can be used in a very easy way with persistent RAM for systems
without flash support. For this systems, with this driver, it's no
more needed add to the kernel the mtd subsystem with advantage in
footprint as I said in the description. In addition, you can save
flash space and store this information only in RAM. I think it's very
useful for embedded systems.

Marco
