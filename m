Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbZFNQLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbZFNQLS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 12:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbZFNQLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 12:11:08 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:47827 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbZFNQLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 12:11:07 -0400
Message-ID: <4A35210D.2030603@xs4all.nl>
Date: Sun, 14 Jun 2009 18:10:53 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Milan Broz <mbroz@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: crypt issue with 2.6.30/gcc 4.4.0?
References: <4A34FD06.2020204@xs4all.nl> <4A351D22.3020404@redhat.com>
In-Reply-To: <4A351D22.3020404@redhat.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-06-14 17:54, Milan Broz wrote:
>> With 2.6.30 I see the Password prompt being repeated, after all the USB
>> messages, as soon as I press the first letter of the password. Each time
>> the password is entered it is not accepted and a new Password: prompt is
>> printed up to a total of three tries.
> 
> password prompt in Fedora is handled completely in userspace in initrd
> by plymouth, then it send password to cryptsetup.

Yes. I saw that in mkinitrd source...

> You did provide neither kernel log messages

The kernel is just booting up, messages scroll by fast, no strange stuff
appears as far as I can see.

> nor description of changes to
> your kernel config... 

I got the 2.6.29.4 .config, copied it into 2.6.30 tree and added ext4 as
fs and nfs4 server support. Nothing much in the area of where the
problem is?

> Try run it in text mode with full kernel log,

How to retrieve the log?

> also try enable some debug mode in plymouth and check exact error message.

Will have look into possibilties there.

> (Are you using mkinitrd from F11? Also see fedora bug 470740)

Indeed. This looks very much like it, although I use a normal PS/2
keyboard and I'll have to count the asterisks.
Thanks for this tip!!

Udo
