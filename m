Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbYDJNsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbYDJNsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 09:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbYDJNsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 09:48:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:42067 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbYDJNsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 09:48:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=T21oZgyEEH0XLk0pvN5Tyiy6ShcPUrQq39K4dIPon6v+/tELyDGyrAvqe31yhIt1yuZs4MNmr2KZH4MjqRIqkPa3IYxYdjWAm4spm0rNqixDeDu3Taa+66zpVBS6QjyRyGfxnf6jA/foIV5bG7EMCcTj5R9aM+t+AQQsBuVy1KM=
Message-ID: <e2e108260804100648w6519f91dpb0313079be733f67@mail.gmail.com>
Date: Thu, 10 Apr 2008 15:48:01 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Rachmel, Nir (Nir)" <rachmel@avaya.com>
Subject: Re: Kernel Oops on hot insertion of USB
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <11486DD9B957EA488E21C44BC8737EFC987F23@307622ANEX5.global.avaya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11486DD9B957EA488E21C44BC8737EFC987F23@307622ANEX5.global.avaya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 3:06 PM, Rachmel, Nir (Nir) <rachmel@avaya.com> wrote:
> I am running linux kernel version 2.6.14.7, and have a problem
> when inserting / removing a disk-on-key device from my system: I get
> a "kernel oops". Using some debugging tools I managed to trace the
> problem down to an event of "double free" that occurs within the
> hot insertion module.
>
> googling didn't help much. Is this a known issue which is resolved in
> later kernel versions?

Can you try yourself whether the kernel oops still occurs with a more
recent kernel, e.g. 2.6.24.4 ? If you can reproduce this with a recent
kernel, the change is much higher that someone will look at this issue
than for kernel 2.6.14.7.

Bart.
