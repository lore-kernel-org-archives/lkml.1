Return-Path: <linux-kernel-owner+w=401wt.eu-S966254AbXDDBxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966254AbXDDBxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966269AbXDDBxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:53:45 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:31368 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966254AbXDDBxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:53:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mUKg9XFsBT9ymBrfeyZOgVNHjifodU28Ox4JzAqD4RY3dr3ejCgJwD7VEGVjGKQ3FYgs3pB+d/PqqTP5nfVDi5r8AGJFvElpmaN8aJ0kh8t/sNJvLaRUiade2OJqi+05uKUNEgIyukKWieDZ42PM7InUXfHMWmzxqY/r4uL/kjk=
Message-ID: <a8e1da0704031853q3f36570ey864cf18126c90f4@mail.gmail.com>
Date: Wed, 4 Apr 2007 01:53:42 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Tom Strader" <tom.strader@xilinx.com>
Subject: Re: Warning: unable to open an initial console.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070403183532.0EE676CC6F2@mail138-cpk.bigfish.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070402190458.0EDD039005F@mail42-fra.bigfish.com>
	 <20070402224923.GA11208@tuatara.stupidest.org>
	 <20070402232012.6716E64781D@mail78-cpk.bigfish.com>
	 <a8e1da0704021834q7911fb56oa0f3f23651ee6be2@mail.gmail.com>
	 <20070403183532.0EE676CC6F2@mail138-cpk.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;
The errno "-6" is defined as:
#define ENXIO            6      /* No such device or address*/

You can try to retrieve the rootfs and add the necessary device file
to it, then reflash the rootfs.

I'm Sorry, I  have no embedded environment to test.

Regards
dave


2007/4/3, Tom Strader <tom.strader@xilinx.com>:
> Hi Dave,
> I'm not sure if I follow.  How do I use mknod with no console to use it
> from?  Can this be done in the init scripts or from u-boot?  Still
> learning so any help would be appreciated.
>
> I was able to trace the console opening to __dentry_open() in fs/open.c
> It does open(inode, f) but returns error -6 if this is any help.  I will
> try to trace it further to see what is wrong.
>
> Thanks,
> Tom
>
>
>
>
>
