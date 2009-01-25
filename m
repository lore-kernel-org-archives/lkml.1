Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbZAYVCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbZAYVCy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 16:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbZAYVCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 16:02:38 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:51079 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbZAYVCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 16:02:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d16By++Puzt+OZy6fCcGbcftwb6HdUL0bF83hcXvwr9n5nvRNO+8LBcG6auIPhVl+J
         c6sqyTV+FQibnhmSCDPsoMeENqAd7324QOevqA8qVBfhlO2al6kcf4uXkzmlAUBygUoI
         XZl/fbSAn7pbc3orVZFdIuDMwfXhxgoQ9nHas=
MIME-Version: 1.0
In-Reply-To: <497CCF9B.6000102@yahoo.fr>
References: <3f9a31f40901251239k3e368feeib33661d82497725b@mail.gmail.com>
	 <497CCF9B.6000102@yahoo.fr>
Date: Mon, 26 Jan 2009 02:32:35 +0530
Message-ID: <3f9a31f40901251302s62949b8fs75c9099e4232b811@mail.gmail.com>
Subject: Re: hdb: status error: error=0x40 <3>{ UncorrectableError }
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: strawks <strawks@yahoo.fr>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 2:16 AM, strawks <strawks@yahoo.fr> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Jaswinder Singh Rajput wrote:
>> Hello all,
>>
>> I added extra IDE drive I get similar messages like below so I replace
>> it another drive but I am still getting similar error messages on
>> 2.6.29-rc2-tip:
>
> Does it work with other kernels?
>

Earlier it was working, I was trying to install another OS, during
format it fails.

>> hdb: status error: status=0x59 { DriveReady SeekComplete DataRequest
> Error }
>> hdb: status error: error=0x40 <3>{ UncorrectableError },
>> LBAsect=208845, sector=0
>> ide: failed opcode was: unknown
>> end_request: I/O error, dev hdb, sector 0
>> Buffer I/O error on device hdb, logical block 0
>> hdb: drive not ready for command
> [...]
>> How can I fix these error.
>
> What is the output of :
>
> smartctl -A -l error /dev/hdb
>

[root@jaswinder jsr]# /usr/sbin/smartctl -A -l error /dev/hdb
smartctl version 5.38 [i386-redhat-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Smartctl: Device Read Identity Failed (not an ATA/ATAPI device)

A mandatory SMART command failed: exiting. To continue, add one or
more '-T permissive' options.
[root@jaswinder jsr]#

--
JSR
