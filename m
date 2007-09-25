Return-Path: <linux-kernel-owner+w=401wt.eu-S1761733AbXIYAAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761733AbXIYAAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 20:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758706AbXIYAAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 20:00:35 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:48610 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110AbXIYAAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 20:00:34 -0400
Message-ID: <46F84F96.9090402@tiscali.nl>
Date: Tue, 25 Sep 2007 02:00:22 +0200
From: roel <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2] Enable link power management for ata drivers
References: <20070924215140.966161778@intel.com> <20070924151320.67f0c332.kristen.c.accardi@intel.com> <46F84460.5090703@tiscali.nl> <Pine.LNX.4.64.0709241624460.24423@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0709241624460.24423@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Tue, 25 Sep 2007, roel wrote:
> 
>>> +	if (!(ap->flags & ATA_FLAG_IPM) || !ata_dev_enabled(dev)) {
>> 	if (!((ap->flags & ATA_FLAG_IPM) && ata_dev_enabled(dev))) {
> 
> int foo(int i, int j) {
>         
>         return !(i & 8) || !j;
> }
> 
> int moo(int i, int j) {
>         
>         return !((i & 8) && j);
> }
> 
> 
> gcc -O2 -S:
> 
> 
> .globl foo
>         .type   foo, @function
> foo:
>         shrl    $3, %edi
>         xorl    $1, %edi
>         testl   %esi, %esi
>         sete    %al
>         orl     %eax, %edi
>         andl    $1, %edi
>         movl    %edi, %eax
>         ret
> .globl moo
>         .type   moo, @function
> moo:
>         shrl    $3, %edi
>         xorl    $1, %edi
>         testl   %esi, %esi
>         sete    %al
>         orl     %eax, %edi
>         andl    $1, %edi
>         movl    %edi, %eax
>         ret

Indeed, no difference, except for the eye. 

do you not consider it an improvement or do you not want to change it?
or
don't you consider it an improvement and want to change it?

Never mind. Disregard if you please.

> - Davide

