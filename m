Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902Ab0ANVAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab0ANVAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956Ab0ANVAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:00:07 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37966 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab0ANVAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:00:06 -0500
MIME-Version: 1.0
In-Reply-To: <20100114205304.GC3814@khazad-dum.debian.net>
References: <1263388596.26006.1.camel@yio.site> <20100114205304.GC3814@khazad-dum.debian.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 14 Jan 2010 21:59:48 +0100
Message-ID: <ac3eb2511001141259t751c6063p8919692a8164e2b@mail.gmail.com>
Subject: Re: Driver-Core: devtmpfs - reset inode permissions before unlinking
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 21:53, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Wed, 13 Jan 2010, Kay Sievers wrote:
>> across the device lifetime by creating hardlinks, in the unusual case
>> that there is a user-writable directory on the same filesystem.
>
> Does a tmpfs mounted in /dev/shm count as "user-writable directory on the
> same filesystem" ?

Not if it's a separate tmpfs mount, which is recommended. Only if it's
just a plain directory on the /dev filesystem.

Udev does the same and resets the permissions of the inode before deleting it.

Kay
