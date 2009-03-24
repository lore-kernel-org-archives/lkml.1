Return-Path: <linux-kernel-owner+w=401wt.eu-S1761076AbZCXOOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761076AbZCXOOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759272AbZCXOGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:06:14 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:47703 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087AbZCXOGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:06:13 -0400
MIME-Version: 1.0
In-Reply-To: <200903241457.29431.arnd@arndb.de>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
	 <200903232037.23768.arnd@arndb.de> <49C8C1FB.2090608@monstr.eu>
	 <200903241457.29431.arnd@arndb.de>
Date: Wed, 25 Mar 2009 00:06:10 +1000
Message-ID: <1d3f23370903240706t7b59b0d9tf05f62a3d5672668@mail.gmail.com>
Subject: Re: [PATCH 44/57] microblaze_v7: termbits.h termios.h
From: John Williams <john.williams@petalogix.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       Remis Lima Baima <remisbaima@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, Mar 24, 2009 at 11:57 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 24 March 2009, Michal Simek wrote:
>> > I haven't gotten around to posting them for review, but I still think
>> > it would be great if we can at least make sure they are identical
>> > so we can remove your versions as soon as we have the asm-generic ones.
>>
>> I tested it some min ago. I just take your termios.h and termbits.h from
>> asm-generic folder. I miss there only #include <asm/uaccess.h> in termion.h.
>>
>> Compilation is OK and kernel works with your files too. For me is easy to use
>> your version. If they are there, I'll use them.
>
> Ok. I did not just mean these specific files, but all the headers in
> general. I assume that you have not had a chance to look into the
> other header files, which is ok. Remis is currently cleaning up bits
> of the generic header files in Linux based on my work, and I asked
> him to look into your tree to see how much can be shared.
>
> Note that there is a problem of binary compatibility with certain headers.
> If e.g. the constants from termbits.h or some data structures slightly
> change, user space will still compile but no longer be compatible
> with other kernel versions, so this needs to be done very carefully.

We are viewing this kernel as a clean break from the past (2.6.20
maintained outside kernel.org).

There will be a new toolchain/glibc/uClibc built against these modern
kernel headers, so I think the binary compatibility issue will have
minimal impact on the existing userbase.  They will just have to
rebuild their apps.  In the space where MicroBlaze finds itself, it's
typical to rebuild an entire system image from source.  Certainly I'm
not aware of anyone moving RPMs around containing MicroBlaze binaries!

Regards,

John
-- 
John Williams,
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
