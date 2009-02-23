Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbZBWICM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbZBWICM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZBWIB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:01:57 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:35305 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbZBWIB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:01:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RiidjK8gFsAqMEPlQ+lGO8DlwuiOl7C2DLurPRMC8a9HY4ozhLw9/tSGyP+st0c9uV
         Fbt8i7/ylPhgWi/9x7C+/zR1ZDNukQw8Mb+hJn+0dtXV/fSheIIrWA0R7QBrsqJAhxuD
         pTxVX9popnNTn/nt8YQv660RDyzg51+GKmUhE=
MIME-Version: 1.0
In-Reply-To: <49A2511B.7030606@zytor.com>
References: <f1f3dd8f0902221910n2722b024pe3ec8748fd3aed5b@mail.gmail.com>
	 <alpine.LFD.2.00.0902221941510.3111@localhost.localdomain>
	 <49A2511B.7030606@zytor.com>
Date: Mon, 23 Feb 2009 18:01:53 +1000
Message-ID: <21d7e9970902230001p509c7a77w9a94b76d552844c9@mail.gmail.com>
Subject: Re: pci 0000:01:00.0: BAR 0: can't allocate resource
From: Dave Airlie <airlied@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       George Rapp <george.rapp@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 5:32 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Linus Torvalds wrote:
>>
>> On Sun, 22 Feb 2009, George Rapp wrote:
>>> In case the attachments don't survive Gmail, dmesg output is at
>>> http://novia.net/~gwr/dmesg_2.6.29-0.33.rc5, and output of 'lspci -vv' is at
>>> http://novia.net/~gwr/lspci-vv_2.6.29-0.33.rc5
>>
>> Can you also show the contents of /proc/iomem?
>>
>> It does look like it's this one:
>>
>>       pci 0000:01:00.0: BAR 0: can't allocate mem resource [0xe0000000-0xe7ffffff]
>>
>> and the problem is that the kernel cannot find enough space to map the
>> required 128MB region for the graphics aperture.
>>
>
> Which makes sense on 32 bits, since by default the entire vmalloc region
> is only 128 MB in size.
>
> Booting with vmalloc=256M or something like that might help.
>

Its not ioremap mapping it, its just getting the resource mapping for
PCI that is needed.

So nothing to do with vmalloc.

Dave.
