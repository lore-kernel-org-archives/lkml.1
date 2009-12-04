Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbZLDPT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbZLDPT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 10:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZLDPT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 10:19:57 -0500
Received: from lucidpixels.com ([75.144.35.66]:37750 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbZLDPT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 10:19:57 -0500
Date: Fri, 4 Dec 2009 10:20:02 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: =?ISO-8859-15?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.32: scsi_wait_scan bug
In-Reply-To: <4B192803.1080008@tremplin-utc.net>
Message-ID: <alpine.DEB.2.00.0912041019310.16957@p34.internal.lan>
References: <alpine.DEB.2.00.0912040943420.3540@p34.internal.lan> <4B192803.1080008@tremplin-utc.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1130160681-1259940002=:16957"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1130160681-1259940002=:16957
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 4 Dec 2009, =C9ric Piel wrote:

> Op 04-12-09 15:44, Justin Piszcz schreef:
>> Hello,
>>
>> Checking the /lib/modules directory for 2.6.32, I noticed this bug still
>> persists:
>> https://lists.linux-foundation.org/pipermail/bugme-new/2007-August/01663=
4.html
>>
>>
>> Was wondering if it should be able to be enabled or disabled in the
>> menuconfig (as you cannot currently see that option)?
> Hi,
>
> Your link eventually leads to this patch:
> http://lkml.indiana.edu/hypermail/linux/kernel/0906.2/00861.html
>
> Isn't this answering your question?
>
> Eric
>

Eric,

Thanks, the last 3 lines of the patch explain it:

+ Still, this option is not exposed as a prompt because little is
+ to be gained by disabling it, whereas people who accidentally
+ switch it off may wonder why their mkinitrd gets into trouble.

Justin.
---1463747160-1130160681-1259940002=:16957--
