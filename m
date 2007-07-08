Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbXGHBJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbXGHBJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 21:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbXGHBJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 21:09:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:41407 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbXGHBJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 21:09:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Jq4yrE+LXBpDopQKAsNESA6DnaGI6LkSw6b3n5xaqER6Mrpct45hgpHHkWBS0/v0lxKAgG+Uo9WHktA5r46hMTfkMLjoJB+x5eZ4jp2MlqWWpbThKAVv7CQCCNSLZSqlGj2KC6l3p5FxjV5i2sUqWKLPty6qtOXaGTtwPVJw9Qg=
Message-ID: <469038EF.7040709@gmail.com>
Date: Sun, 08 Jul 2007 10:07:59 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc6-mm1 -- BUG - EIP: [<c01a77a1>] sysfs_addrm_finish+0x1c2/0x226
 SS:ESP 0068:c5ff9db8
References: <a44ae5cd0707030932h16a90ca3j8ad65b7a3ec64b03@mail.gmail.com>	 <20070703094916.e60d4df7.akpm@linux-foundation.org>	 <468B3CFF.7020903@gmail.com>	 <a44ae5cd0707040036x74c82dcci12b0a3f83a27af56@mail.gmail.com>	 <468C9E74.4080606@gmail.com>	 <a44ae5cd0707060101g38147b2gb3d33d9903082113@mail.gmail.com>	 <468F36F5.4010803@gmail.com> <a44ae5cd0707071753g6dd4445bsaac2e2296327e510@mail.gmail.com>
In-Reply-To: <a44ae5cd0707071753g6dd4445bsaac2e2296327e510@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane wrote:
>> Weird, that's unrelated path.  It seems sd->s_parent is NULL in
>> sysfs_link_sibling(), which doesn't make sense because it's being called
>> from sysfs_create_link() which makes sure parent_sd isn't NULL &&
>> sysfs_addrm_start() should have caused oops earlier as it deferences
>> parent_sd.
>>
>> Can you please retry the test (test clean 2.6.22-rc6-mm1, apply patch,
>> rebuild and test)?
> 
> I downloaded linux-2.6.22-rc6.tar.bz2, applied 2.6.22-rc6-mm1 and then
> applied your second patch.  I still get the same OOPS I reported to you
> and Andrew in the image I attached to my previous message.

Thanks a lot.  Just in case, if you remove the patch (patch -R -p1), the
oops goes away, right?

-- 
tejun
