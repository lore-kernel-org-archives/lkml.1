Return-Path: <linux-kernel-owner+w=401wt.eu-S932658AbZACXM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbZACXM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 18:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760075AbZACXMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 18:12:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:63018 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941AbZACXMo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:12:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=f+/1ZfmcnAQW1gw0Jz3lXC+aiGR0vLSyYrKynicpZ0GrVIpcBxGPm7Q9711QC5W921
         RQXVpM6fK/3MFjmQUnBRJTHxjyIQg8F3IM+A20FEBoKRVqYR6fGLw923by0sIOQW32Ky
         Otedxauo6HXH19hBSJGWVJuZlNvbfSbXxSt2M=
Message-ID: <e9e943910901031512j62f4eb42j8ff6cf7105683449@mail.gmail.com>
Date: Sat, 3 Jan 2009 23:12:41 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: document ext3 requirements
Cc: "=?WINDOWS-1252?Q?Martin_MOKREJ=8A?=" 
	<mmokrejs@ribosome.natur.cuni.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
In-Reply-To: <20090103222957.GG1666@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20090103123813.GA1512@ucw.cz>
	 <495FD5D7.2040907@ribosome.natur.cuni.cz>
	 <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com>
	 <20090103222957.GG1666@elf.ucw.cz>
X-Google-Sender-Auth: 1f0aadf1052aa12a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/3 Pavel Machek <pavel@suse.cz>:
> On Sat 2009-01-03 22:17:15, Duane Griffin wrote:
>> [Fixed top-posting]
>>
>> 2009/1/3 Martin MOKREJŠ <mmokrejs@ribosome.natur.cuni.cz>:
>> > Pavel Machek wrote:
>> >> readonly mount does actually write to the media in some cases. Document that.
>> >>
>> > Can one avoid replay of the journal then if it would be unclean?
>> > Just curious.
>>
>> Nope. If the underlying block device is read-only then mounting the
>> filesystem will fail. I tried to fix this some time ago, and have a
>> set of patches that almost always work, but "almost always" isn't good
>> enough. Unfortunately I never managed to figure out a way to finish it
>> off without disgusting hacks or major surgery.
>
> Uhuh, can you just ignore the journal and mount it anyway?
> ...basically treating it like an ext2?

I'm afraid not, ext2 won't mount an FS with EXT3_FEATURE_INCOMPAT_RECOVER set.

> ...ok, that will present "old" version of the filesystem to the
> user... violating fsync() semantics.
>
> Still handy for recovering badly broken filesystems, I'd say.
>
>                                                                        Pavel

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
