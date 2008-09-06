Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbYIFFuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbYIFFuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 01:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYIFFuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 01:50:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:58370 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbYIFFue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 01:50:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CvNj5CIDChtax7ujWi6uI7fmMjCx+YoDA/Mdmw+hErUe1KMC+MXo0NR8d7aJo1lKN1
         +VZPDQbr6EyvkQRbuBp3aXwM3/GgBkOJe9fo9tKUDPF6yd7oCn2I9q9HU2XxPNJ3JIND
         qGy7I0IpPB52+B6CCEWoUi5mVpymhULOWVgNw=
Message-ID: <86802c440809052250h194a3e7dnd088fa1228dff109@mail.gmail.com>
Date: Fri, 5 Sep 2008 22:50:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes (NOPL issue)
Cc: "Robert Hancock" <hancockr@shaw.ca>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "x86 maintainers" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48C201E5.7080703@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.HDZlnwhQIaOU7WkvenWvWDveLiI@ifi.uio.no>
	 <fa.uHa5kqSRJ8gj0H3r9BmGsTqRvFI@ifi.uio.no> <48C200F8.90705@shaw.ca>
	 <48C201E5.7080703@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2008 at 9:07 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Robert Hancock wrote:
>>>
>>> if so, should only test on VIA chips.
>>
>> The virtual CPUs are more of a problem. They can't be distinguished from
>> the real CPU models they are emulating other than by actually testing.
>
> Right, hence the first-principles test.  In theory we could just execute the
> test on ALL CPUs, but I have excluded family < 6 simply because there is a
> (very) remote possibility one of them might have used that opcode for
> something completely different.

oh, is the one that is going to fix booting with VirtualBox?

YH
