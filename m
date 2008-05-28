Return-Path: <linux-kernel-owner+w=401wt.eu-S1752230AbYE1Rd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbYE1Rd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 13:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYE1Rdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 13:33:47 -0400
Received: from lucidpixels.com ([75.144.35.66]:41620 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYE1Rdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 13:33:46 -0400
Date: Wed, 28 May 2008 13:33:46 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: =?ISO-8859-15?Q?Jens_B=E4ckman?= <jens.backman@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Performance Characteristics of All Linux RAIDs
 (mdadm/bonnie++)
In-Reply-To: <95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0805281333080.29755@p34.internal.lan>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-2044578589-1211996026=:29755"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-2044578589-1211996026=:29755
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 28 May 2008, Jens B=E4ckman wrote:

> On Wed, May 28, 2008 at 10:53 AM, Justin Piszcz <jpiszcz@lucidpixels.com>=
 wrote:
>> Results:
>>
>> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
>> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.txt
>
> Either the RAID 1 read speed must be wrong, or something is odd in the
> Linux implementation. There's six drives that can be used for reading
> at the same time, as they contain the very same data. 63MB/s
> sequential looks like what you would get from a single drive.
>

The RAID1 is correct.  As has been discussed on this list before, you will=
=20
only see raid speed > 1 disk if you run 2(?, or 3 minimal) threads=20
from the same device (raid1).

Justin.
---1463747160-2044578589-1211996026=:29755--
