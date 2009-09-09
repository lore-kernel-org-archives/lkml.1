Return-Path: <linux-kernel-owner+w=401wt.eu-S1751797AbZIIHEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbZIIHEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 03:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZIIHEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 03:04:09 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:46591 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbZIIHEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 03:04:09 -0400
MIME-Version: 1.0
In-Reply-To: <1252442847.16422.0.camel@maxim-laptop>
References: <b2cdc9f30909081157r3087f707ve3a0cff77f46941a@mail.gmail.com>
	 <1252442847.16422.0.camel@maxim-laptop>
Date: Wed, 9 Sep 2009 08:04:09 +0100
X-Google-Sender-Auth: 315b8b81b3831e58
Message-ID: <b2cdc9f30909090004n3d19e2f5u80a6d6d08ec00144@mail.gmail.com>
Subject: Re: Machine resumes straight after suspend to RAM (or disk)
From: Alex Bennee <kernel-hacker@bennee.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/8 Maxim Levitsky <maximlevitsky@gmail.com>:
> On Tue, 2009-09-08 at 19:57 +0100, Alex Bennee wrote:
< snip>
>> The machine is fairly standard Intel Core Duo based system (lspci
>> attached). However when I execute pm-suspend (or Gentoo's own
>> hibernate-script) the system does suspend but resumes immediately. To
>> add insult to injury the ethernet doesn't come back properly and needs
>> a reboot to reset it.
>>
<snip>
>
> Try to unload ehci_hcd before suspend.

That worked. Is it known why ehci_hcd causes a problem?

Unfortunately the network card never recovers but I suspect
that is another problem.

-- 
Alex, homepage: http://www.bennee.com/~alex/
http://www.half-llama.co.uk
