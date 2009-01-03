Return-Path: <linux-kernel-owner+w=401wt.eu-S1760293AbZACWR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293AbZACWR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 17:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759598AbZACWRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 17:17:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:55372 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbZACWRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 17:17:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=qG/GrMJe7mbppIiTEDjIizgDGLB7d2Q30YboKl5vG6ov4Fh9QPfTGrSdB0UJh9+UFJ
         tTwBqa5IQ1t00qMWjnvecsGgm2o9QOkZhD57BL6sYpgYU1HTiEcm/aylqd3So4Fi92U0
         UUvAmSzAW9aQKc9l/pqVoP2RRop+++rwjfGow=
Message-ID: <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com>
Date: Sat, 3 Jan 2009 22:17:15 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "=?WINDOWS-1252?Q?Martin_MOKREJ=8A?=" 
	<mmokrejs@ribosome.natur.cuni.cz>
Subject: Re: document ext3 requirements
Cc: "Pavel Machek" <pavel@suse.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
In-Reply-To: <495FD5D7.2040907@ribosome.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20090103123813.GA1512@ucw.cz>
	 <495FD5D7.2040907@ribosome.natur.cuni.cz>
X-Google-Sender-Auth: 870a0672ef963fe4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Fixed top-posting]

2009/1/3 Martin MOKREJŠ <mmokrejs@ribosome.natur.cuni.cz>:
> Pavel Machek wrote:
>> readonly mount does actually write to the media in some cases. Document that.
>>
> Can one avoid replay of the journal then if it would be unclean?
> Just curious.

Nope. If the underlying block device is read-only then mounting the
filesystem will fail. I tried to fix this some time ago, and have a
set of patches that almost always work, but "almost always" isn't good
enough. Unfortunately I never managed to figure out a way to finish it
off without disgusting hacks or major surgery.

> M.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
