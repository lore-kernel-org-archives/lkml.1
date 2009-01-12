Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbZALWYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbZALWYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbZALWYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:24:13 -0500
Received: from ottmail.xandros.com ([142.46.212.35]:42032 "EHLO
	ottmail.xandros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbZALWYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:24:12 -0500
X-Greylist: delayed 707 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2009 17:24:12 EST
Date: Mon, 12 Jan 2009 17:11:54 -0500
From: Woody Suwalski <woodys@xandros.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: Matthias Kaehlcke <matthias@kaehlcke.net>, linux-kernel@vger.kernel.org
Message-ID: <496BC02A.2020402@xandros.com>
In-Reply-To: <496B597A.7020807@lougher.demon.co.uk>
References: <20090112140822.GB23365@traven>
References: <496B597A.7020807@lougher.demon.co.uk>
Subject: Re: [BUG?] SQUASHFS error: Major/Minor mismatch
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Lougher wrote:
> Matthias Kaehlcke wrote:
>> i get the following error when trying to mount a squashfs partition on
>> an ARM system (edb9302) with linux 2.6.29-rc1:
>>
>> mount /dev/mtdblock6 /mnt/
>> SQUASHFS error: Major/Minor mismatch, older Squashfs 3.1 filesystems
>> are unsupported
>> mount: mounting /dev/mtdblock6 on /mnt/ failed: Invalid argument
>>
>> the image has been created using mksquashfs v3.4:
>>
>> mksquashfs . /tmp/rootfs.squfs -le -noappend
>>
>
> You have to use the latest version of Mksquashfs in CVS available
> from http://squashfs.org.
>
> git-cvsimport -v -d 
> :pserver:anonymous@squashfs.cvs.sourceforge.net:/cvsroot/squashfs 
> squashfs
>
> Phillip
>
Does not look good! I have squashfs images which work OK in 3.3 and 3.4, 
but now I try to boot 2.6.29-rc1 and it can not mount my squashfs root 
partition!
Does it mean that squashfs4 is not backward-compatible? If so - I can 
not use it - all my images are generated on 3.3 .. 3.4...

Woody

-- 
Woody Suwalski, Xandros, Ottawa, Canada, 1-613-842-3498 x414

