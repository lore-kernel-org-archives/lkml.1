Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbZF0TMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbZF0TMP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 15:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZF0TMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 15:12:10 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:40423 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZF0TMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 15:12:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JkrVGID4LwNviw6I2vhcighZBZwNXiGRpLgWojdV9bCFipiH0B39D48kqHNjqJh6bY
         9m0ZBn71ITr3FD9MhAHJmG0BDY5tmdtO45olFupQ2tElq/idZkcFRAJ9rMdrZkmILi4u
         jrvhUylv/YbmVf4uORxfnUY8y8wxPL7ilWsv0=
MIME-Version: 1.0
In-Reply-To: <b6a2187b0906271109q2194cadbv8d20b4bda82bde19@mail.gmail.com>
References: <4A44EBEE.9070503@numericable.fr>
	 <200906262139.23367.bzolnier@gmail.com>
	 <4A45E095.5070608@numericable.fr>
	 <b6a2187b0906271109q2194cadbv8d20b4bda82bde19@mail.gmail.com>
Date: Sun, 28 Jun 2009 03:12:11 +0800
Message-ID: <b6a2187b0906271212u78c00562oaf84ffd740d4aecb@mail.gmail.com>
Subject: Re: [REGRESSION] 2.6.29=>2.6.30 suspend to ram regression (IDE 
	related)
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Etienne Basset <etienne.basset@numericable.fr>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, davem@davemloft.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 2:09 AM, Jeff Chua<jeff.chua.linux@gmail.com> wrote:
> On Sat, Jun 27, 2009 at 5:04 PM, Etienne
> Basset<etienne.basset@numericable.fr> wrote:
>>>> kernel v2.6.29 suspends to RAM reliably on my computer; v2.6.30 doesn't resume after STR
>
> Same problem on Thinkpad X61. STD STR suspended ok. Upon resume,
> everything "seems" fine for about 100 seconds. Then mouse, keyboard
> frozen.
>
>>>> I tried also 2.6.31-rc1 doesn't work either
>>>> etienne@etienne-desktop:~/linux-2.6$ git bisect bad
>>>> 2f0d0fd2a605666d38e290c5c0d2907484352dc4 is first bad commit
>>>
>>> Does the following patch fix it?
>> Yes, it works now
>
> Works for me too with the patch.

UPDATE ...

STR able to resume and works after >100 seconds

STD able to resume but failed after 100 seconds (could be 300 seconds)
but eventually failed. Everything seems ok, but mouse and keyboard
just freezed suddenly. Just haven't really time it enough.

Jeff.
