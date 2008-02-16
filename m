Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbYBPWhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbYBPWhz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 17:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYBPWhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 17:37:45 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:56356 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYBPWho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 17:37:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GyM6dp9PVr9cDBZCe8suPeCz2Xe+97JBNh3pA6Xq4F0PNyk00Q+0b2wAbxYZIEcLrC0qW00T8sjUKKMj4A5vWibChhRsxnUb6iUqhfyXlCg6DlJpQqrPDRD8bhpdUkylhq7UvVk/h2tywUc4F7u/rIi3oZYlZhpm02riiwRevpw=
Message-ID: <47B765B1.1030709@gmail.com>
Date: Sat, 16 Feb 2008 23:37:37 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tilman Schmidt <tilman@imap.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc2 regression: LVM cannot find volume group
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>	<47B73616.9050303@imap.cc> <20080216201206.1452cfe7@core>
In-Reply-To: <20080216201206.1452cfe7@core>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2008 09:12 PM, Alan Cox wrote:
> On Sat, 16 Feb 2008 20:14:30 +0100
> Tilman Schmidt <tilman@imap.cc> wrote:
> 
>> 2.6.25-rc2 fails to bring up my openSUSE 10.3 PC because LVM
>> cannot find the volume group containing the root file system.
>> 2.6.25-rc1 has the same problem, 2.6.24 works fine.
> 
> Compile in SCSI disk support. Modular even if loaded in initrd it seems
> to have broken somewhere.

# CONFIG_SYSFS_DEPRECATED is not set

I would suspect this.

Try to upgrade to at least lvm 2.02.29 (I guess this is the first version which 
understands the new sysfs layout).
