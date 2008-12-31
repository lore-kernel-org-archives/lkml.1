Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbYLaIgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbYLaIgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbYLaIgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:36:40 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:38162 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbYLaIgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:36:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XfdLwdOh9uM5mURsCl6bCOKu6/CNd6Wq1KHdVjyCKaZCNZHmwQtwPReC8NCvodORUA
         qbBezDnKx8u/d5SSOE9VSa5iNnQBY3RWVRN49HQthIN86MwT9u3C9sKjlmCs1lPWLQf9
         7E2MSssoua9UDkyTJP2REZisJt5fkMV0yEkSk=
Message-ID: <a00b9da20812310036t69387d1by2602050624f7e9b@mail.gmail.com>
Date: Wed, 31 Dec 2008 09:36:36 +0100
From: "Frank Groeneveld" <frankgroeneveld@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.28 regression: Hang after hibernate
In-Reply-To: <a00b9da20812281234u76da2ef5tb715f4c409eaf37c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a00b9da20812281234u76da2ef5tb715f4c409eaf37c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm still investigating this problem, but it seems to be the r8169
driver. When I compile it as a module and unload it, the hibernate
works fine. With kernel 2.6.27.7 I could just keep it loaded
(built-in).

Frank

2008/12/28 Frank Groeneveld <frankgroeneveld@gmail.com>:
> Hi,
>
> Today I tried the new kernel and found out it has a regression. With
> kernel 2.6.27 I never had problems resuming from hibernate, but with
> 2.6.28 it hangs. The output is something like this (it's not exactly,
> I skipped some words that are before the PCI lines):
>
> PM: read .. MB in .. seconds
> SDA: Synchronizing SCSI cache
> r8169: PME# enabled
> PCI INT A disabled
> PCI INT D disabled
> PCI INT B disabled
> PCI INT C disabled
> PCI INT D disabled
> PCI INT A disabled
> Disabling non-boot CPUs
> CPU1 is now offline
> CPU1 is down
> CPU2 is now offline
> CPU2 is down
> CPU3 is now offline
> CPU3 is down
> SMP Alternatives: switching to UP code
>
> I first thought it's the same as bug 12155, but I'm not sure it is.
> If there's any other ouput I can send to help, let me know.
>
> Regards,
> Frank Groeneveld
>
