Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295Ab0BNJxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 04:53:55 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:45563 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab0BNJxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 04:53:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uj9zuV/OCQdov7TbrVY4f43/X1oE9jX+QpcaS8AZ7eXfXOlJUZqrbGlLq8tiXuNPMX
         BZeSbE2B+GIYQyywh/RddnOoHoFM3btEpsXfY5Lf5mTsBn+b8KlTXLaJr7wMO6g2KGSQ
         G+lDTIA7JPDIv2CWEVeKgEWLk8mm35ERo9zZM=
Message-ID: <4B77C803.6080900@gmail.com>
Date: Sun, 14 Feb 2010 01:53:07 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Phillip Lougher <phillip@lougher.demon.co.uk>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, lasse.collin@tukaani.org,
       mirrors@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       users@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org>	<20100212150137.648dca7c@hyperion.delvare>	<4B75A5CF.70308@lougher.demon.co.uk>	<20100212203209.0cb8afc3@hyperion.delvare>	<4B75B2A6.5080006@lougher.demon.co.uk>	<20100212225923.36a67112@hyperion.delvare>	<4B75E6C7.5030106@lougher.demon.co.uk>	<20100213083115.5cf8d4a4@hyperion.delvare>	<4B7729B5.4040609@lougher.demon.co.uk> <20100214103226.64736ce5@hyperion.delvare>
In-Reply-To: <20100214103226.64736ce5@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/10 01:32, Jean Delvare wrote:
> Hi Phillip,
>
> On Sat, 13 Feb 2010 22:37:41 +0000, Phillip Lougher wrote:
>> Embedded and enterprise distro users are usually stuck on ancient kernels that
>> were downloaded from kernel.org and patched *years ago*.  The reason they're
>> stuck on them is due to local modifications, and so they're not going to be
>> downloading ancient vanilla kernels from kernel.org now.
>
> They perfectly could. This is exactly what we're doing at Suse and I can
> easily imagine other companies follow the same model. We store our
> local changes as patches on top of the old kernel version. When a new
> developer joins the team and needs to setup a working tree, our setup
> script gets the patches from our internal repository, fetches the
> relevant kernel tarball from kernel.org, unpacks it and applies all the
> patches.
>
> This is one of the reasons why others have been claiming in this
> discussion: it would be weird if files which were previously available
> would suddenly disappear. We can discuss the cost and benefits of any
> change done to the tree structure, compression formats etc. but please
> do not assume that nobody is downloading the old files from kernel.org.
>
> Personally I wouldn't mind at all if old files would disappear and our
> tools have to be adjusted accordingly, as long as it happens only once
> in a long while and not on a regular basis by (broken) design.
>


not trying to cut in, but the best example I can see for this
(hopefully), or a good example of just changing everything
(cut the middle man per say)is libc there is no libc-2.11.90.so 
.tar.gz(etc..)only through git(but could be wrong).

My system that I built is only handling everything(meaning every package 
as much as possible)through git.


Justin P. Mattock
