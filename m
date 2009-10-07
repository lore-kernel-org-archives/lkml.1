Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbZJGXbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbZJGXbC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 19:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbZJGXbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 19:31:01 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:39252 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbZJGXbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 19:31:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=KoxsdV880SBhspzfG62cdiwSu0pZKMOVCHM657PJlL+OEgALf0HQEKYKbPHcxND5+U
         2TfJB+BiNqeGoFk1oSxewvPHjN4cVdu+T8Szykq79vn+ZhWQxMqX1zha9nbkwuDzlt3r
         ImQRoVQd9qTPPEv5pID3K4G84KB71QLc6c+JM=
MIME-Version: 1.0
In-Reply-To: <20091008001554.0ed1212c@lxorguk.ukuu.org.uk>
References: <haj471$fn8$1@ger.gmane.org>
	 <20091008001554.0ed1212c@lxorguk.ukuu.org.uk>
Date: Wed, 7 Oct 2009 18:30:22 -0500
X-Google-Sender-Auth: f4175d52d29d2eee
Message-ID: <cdb43e8a0910071630q41e1f42ekc5d5023d96dfde37@mail.gmail.com>
Subject: Re: iso9660 mount problem
From: Jack Byer <ojbyer@usa.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 6:15 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 07 Oct 2009 17:22:02 -0500
> Jack Byer <ojbyer@usa.net> wrote:
>
>> I have a CD of a commercial software program that I am attempting to run
>> under wine. The CD works without problems under Windows, but when I mount
>> it on linux the file system appears to be empty (no files or
>> directories). The drive is capable of reading the CD because "strings
>> /dev/cdrom" works.
>>
>> What would I need to do in order to troubleshoot this problem?
>
> Firstly check what occurs if you mount it by hand with -t iso9660 and
> with -t udf. Secondly check dmesg for any diagnostics from the mount such
> as corrupt metadata on the CD.
>
>

It will not mount as UDF:

UDF-fs: No VRS found
UDF-fs: No partition found (1)

As iso9660:

mount -t iso9660 /dev/cdrom /mnt/cdrom
mount: block device /dev/sr0 is write-protected, mounting read-only

dmesg:

ISO 9660 Extensions: Microsoft Joliet Level 1
ISO 9660 Extensions: IEEE_P1282

I tried this on three different machines all with the same result.
