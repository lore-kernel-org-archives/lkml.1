Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbZALUNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbZALUNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbZALUNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:13:31 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:45176 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbZALUNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:13:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=csuMWtYOIBVasAxoUkTyDhHzUU+dEAl8L7Ygvco8Mq5Z5gfq1X3R9FJOh0XNHYH2CA
         kWYP9Y20dfgocvmpgm6bqG81F5Mz2dLepdBGi8buTSqi6swOZ6vkOCLpF4oeyYxPn2ts
         ZSP7Y7jKtkwrHnt3oYCKcb8MGxhLpFODbejtw=
Message-ID: <524f69650901121213l76dd4b6ap831d6da16876422f@mail.gmail.com>
Date: Mon, 12 Jan 2009 14:13:29 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: linux-next: Tree for January 12 (cifs vs. staging)
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, sfrench@samba.org
In-Reply-To: <20090112193218.GA7751@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090112154539.4857f533.sfr@canb.auug.org.au>
	 <496B899E.7060605@oracle.com>
	 <524f69650901121058g73c8022eif1d1bcca5c0e01fa@mail.gmail.com>
	 <20090112191330.GC7111@suse.de>
	 <524f69650901121123i1765dc3fye3ce636c91dd25bd@mail.gmail.com>
	 <20090112193218.GA7751@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 1:32 PM, Greg KH <gregkh@suse.de> wrote:
> On Mon, Jan 12, 2009 at 01:23:07PM -0600, Steve French wrote:
>> Is there some magic compile option alternative (other than renaming
>> the function, which may be ok, since others probably don't depend on
>> it)?  MD5Init is used outside fs/cifs/md5.c so can't be static
>
> No, you should rename it to cifs_md5init to show that it is only for the
> cifs module to use.  Try not to polute the global namespace with generic
> function names.

Looks like cifs has the following related functions which I can rename
if that makes it easier:
001a2e9 R_386_PC32        MD5Final
0001a302 R_386_PC32        MD5Update
0001a38c R_386_PC32        MD5Init
0001a39f R_386_PC32        MD5Update

Any others that I missed ...

-- 
Thanks,

Steve
