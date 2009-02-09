Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZBIMB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZBIMB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 07:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZBIMBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 07:01:16 -0500
Received: from mail-ew0-f26.google.com ([209.85.219.26]:40265 "EHLO
	mail-ew0-f26.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbZBIMBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 07:01:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TqCVmcw5X0h70U4QoQtJzGDPviUhwOPC/BJSF5zlQTgJ6BhDUZVxJ4NQE3ocSTGa6b
         KC//T97DfxzUPrJC98cpcWbJ9Ke47ZdqglKO3lZ5jOu7NvcVwjqZDNnbyxG9U094szPY
         LObk8DILh2w/mGcrVN9syxMpDY8dZBb38PuiA=
MIME-Version: 1.0
In-Reply-To: <498C9876.3060208@redhat.com>
References: <a4423d670902060935y59e540beta417144935416560@mail.gmail.com>
	 <498C7671.1050309@redhat.com>
	 <a4423d670902061004i424817e1vd699a61e335f010a@mail.gmail.com>
	 <498C9876.3060208@redhat.com>
Date: Mon, 9 Feb 2009 15:01:13 +0300
Message-ID: <a4423d670902090401k716d054eo25640aa2207beca7@mail.gmail.com>
Subject: Re: next-20090206: deadlock on ext4
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/6 Eric Sandeen <sandeen@redhat.com>:
> Alexander Beregalov wrote:
>> 2009/2/6 Eric Sandeen <sandeen@redhat.com>:
>>> Alexander Beregalov wrote:
>>>> Hi
>>>>
>>>> I run dbench on ext4 on loop device.
>>>>
>>>> EXT4-fs: barriers enabled
>>>> kjournald2 starting: pid 2420, dev loop0:8, commit interval 5 seconds
>>>> EXT4 FS on loop0, internal journal on loop0:8
>>>> EXT4-fs: delayed allocation enabled
>>>> EXT4-fs: file extents enabled
>>>> EXT4-fs: mballoc enabled
>>>> EXT4-fs: mounted filesystem loop0 with ordered data mode
>>>> JBD: barrier-based sync failed on loop0:8 - disabling barriers
>>>>
>>>> INFO: task pdflush:2339 blocked for more than 120 seconds.
>>> Looks a lot like a bug I filed:
>>>
>>> http://bugzilla.kernel.org/show_bug.cgi?id=12579
>>>
>>> but I'm having trouble reproducing it, now.  I'll try dbench!
>> Yes, I can reproduce it easy with dbench.
>
> Do you only hit it on loopback?  What is the filesystem hosting the loop
> file?

I have reproduced it with 2.6.29-rc4.
Loop file was on XFS.
I can not reproduce it on ext4 on raw device.
Let me know if I can do anything else to help resolving it.
