Return-Path: <linux-kernel-owner+w=401wt.eu-S1761757AbZAOASY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761757AbZAOASY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759153AbZAOASD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:18:03 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:63578 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952AbZAOASA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:18:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XojOVVlZsE4YbUbCEP2GIucCs/W0NJFk2KfKwfhLEPHhM7l/Mz1/girCFOW1xUBB9C
         /435/6+c9Mh+Hzk5huyNDmWFt39GF1x2YM2alU+dD9WR4Gq2pIm3ZPcjgxmRPjvHGyam
         JLMdqXbHWNAinYO9Lrk9KntxYu779vLrSSsfk=
Message-ID: <3e8340490901141617ycda4d86n1e5c553e06ced6f@mail.gmail.com>
Date: Wed, 14 Jan 2009 19:17:59 -0500
From: "Bryan Donlan" <bdonlan@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: OOPS and freeze on 2.6.29-rc1 on xen-x86
Cc: linux-kernel@vger.kernel.org, "Jeremy Fitzhardinge" <jeremy@goop.org>
In-Reply-To: <20090114160932.74c68a4d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3e8340490901112247y4d82a71ah23ab1453ca0d9819@mail.gmail.com>
	 <20090114160932.74c68a4d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 7:09 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 12 Jan 2009 01:47:40 -0500
> "Bryan Donlan" <bdonlan@gmail.com> wrote:
>
>> After testing 2.6.29-rc1 on xen-x86 with a btrfs root filesystem, I
>> got the OOPS quoted below and a hard freeze shortly after boot
>> (running update-grub of all things).
>> Boot messages and config are attached.
>>
>> This is on a test system, so I'd be happy to test any patches.
>
> Are you able to reproduce this without using btrfs?
>

Hi,

Sorry, it looks like this message made it through after all - I had
resent it with inline config/etc after it appeared to vanish into a
spam filter somewhere, and discussion is happening in that thread
instead: http://thread.gmane.org/gmane.linux.kernel/779350
(message-id <20090112172613.GA8746@shion.is.fushizen.net>)

It's been bisected there, and I believe there's a revert queued
already as a short-term fix.

Thanks,

Bryan Donlan
