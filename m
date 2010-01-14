Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083Ab0ANVpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab0ANVpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489Ab0ANVpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:45:31 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43421 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab0ANVp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:45:29 -0500
MIME-Version: 1.0
In-Reply-To: <20100114210743.GE3814@khazad-dum.debian.net>
References: <1263388596.26006.1.camel@yio.site> <20100114205304.GC3814@khazad-dum.debian.net> 
	<ac3eb2511001141259t751c6063p8919692a8164e2b@mail.gmail.com> 
	<20100114210743.GE3814@khazad-dum.debian.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 14 Jan 2010 22:45:12 +0100
Message-ID: <ac3eb2511001141345w64d42ceckb4d73815298761c2@mail.gmail.com>
Subject: Re: Driver-Core: devtmpfs - reset inode permissions before unlinking
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 22:07, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Thu, 14 Jan 2010, Kay Sievers wrote:
>> On Thu, Jan 14, 2010 at 21:53, Henrique de Moraes Holschuh
>> <hmh@hmh.eng.br> wrote:
>> > On Wed, 13 Jan 2010, Kay Sievers wrote:
>> >> across the device lifetime by creating hardlinks, in the unusual case
>> >> that there is a user-writable directory on the same filesystem.
>> >
>> > Does a tmpfs mounted in /dev/shm count as "user-writable directory on the
>> > same filesystem" ?
>>
>> Not if it's a separate tmpfs mount, which is recommended. Only if it's
>> just a plain directory on the /dev filesystem.
>
> Yeah, I noticed the abusurdity of my question when I re-read it, thanks for
> being kind in the reply.
>
> That said, this does fix a possible security problem when a misconfigured
> system is used, and the fix looks rather simple...  Can it go to -stable
> eventually, even if it is months in the future, after it gets some testing
> in .34 ?   Minor problems are still problems...

Sure, we could do that. There is some stuff in the current .33 kernel,
which could go into .32-stable too, if that's useful.

Kay
