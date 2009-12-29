Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbZL2Wcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbZL2Wcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 17:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbZL2Wcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 17:32:35 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35334 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbZL2Wce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 17:32:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UweNFSHYIjHH2ylZGdPANKLxSWtaEGht4gQkyMG/FmzoBUw5/aqUDyop42xZWwDwtK
         /4LJtahkqePgBa5MS2Ygr1gjit0tsKjmq3qk6GtRHQ2UK5kBONwkX5qoJBLL1U0u/8dz
         zZwe0PxcDD2rY0IBGFATn3Zl83tIrpl4BqAF8=
MIME-Version: 1.0
In-Reply-To: <200912292304.46435.rjw@sisk.pl>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
	 <srmJ8vMxKPH.A.L5E.RyhOLB@chimera>
	 <99598f620912290818s29ece3d2uf36bc9125b46ea48@mail.gmail.com>
	 <200912292304.46435.rjw@sisk.pl>
Date: Tue, 29 Dec 2009 22:32:31 +0000
Message-ID: <99598f620912291432l5f0698a4p7b770187e439c08c@mail.gmail.com>
Subject: Re: [Bug #14436] Computer becomes unusable without any apparent 
	reason
From: =?ISO-8859-1?Q?Lu=EDs_Picciochi_Oliveira?= <pitxyoki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 10:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday 29 December 2009, Luís Picciochi Oliveira wrote:
>> Hi,
>> The bug is present on 2.6.32 and subsequent versions (2.6.32.1, 2.6.32.2).
>> It has been resolved as of 2.6.33-rc1.
>
> Thanks for the update.
>
> Is it known how it was fixed in 2.6.33-rc1 or do you just see that the bug is
> not present in there any more?

Hi,
Like I reported at [1], I strongly believe this was the same as bug as
#12794, which was resolved by a patch resulting from my feedback and
Jussi Kivilinna's work. After I enabled memory debug like suggested on
bug #14436, everything pointed in the direction of that bug.
The issue was solved after applying Jussi's patch. That patch has been
commited to the mainline kernel and I can assert that since then the
bug didn't occur again.

Regards,
Luís Picciochi

[1] http://bugzilla.kernel.org/show_bug.cgi?id=14436
