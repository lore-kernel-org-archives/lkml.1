Return-Path: <linux-kernel-owner+w=401wt.eu-S934963AbXHHOsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934963AbXHHOsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934712AbXHHOru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:47:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:44169 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934628AbXHHOrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:47:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F/upbgM94kS5YONsFvqkYxNry4LxdcaaGcCyPcjwBF7UA2jrqhGq9C34+8UA1Q5wnd8HZX3DrY41p4jLMX3OqzndQwutHaGkyTEnRWZQaeu5GExp2Y27omUPZ4CPHmQ+YxXI5H4YWyJy4sU9BAJsd1ZGJtQYo1bQorCgdvnTFiw=
Message-ID: <5699f8f00708080747u17b7a0e1lb919d61ca6e3ea9c@mail.gmail.com>
Date: Wed, 8 Aug 2007 16:47:46 +0200
From: "Wander Winkelhorst" <w.winkelhorst@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Data corruption
In-Reply-To: <5699f8f00708080744m42eebdeaqdc42daffec1b7d8d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708072007.27343.paul.pinault@disk91.com>
	 <46B906DD.5000501@redhat.com>
	 <200708080831.10141.paul.pinault@disk91.com>
	 <5699f8f00708080744m42eebdeaqdc42daffec1b7d8d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, paul <paul.pinault@disk91.com> wrote:
>  Hi, thank you for your answer, actually I removed 2Gb of physical memory and
> the problem gone away .. but my system needs 4Gb.
>
> I reproduce it under Xen and without xen (on a standard kernel) I can't tell
>  you how mutch difference I have betwwen files, regarding a 4 month system
> running on these condition, I think the number of errors are rare but
> existing, during my tests with 100M files I did not get a lot of error, so we
> can assume 2 or 3 bytes in error in 300M files... (expectation)
>
> I try to avaoid it by disabeling memory relocation on my MB ... in that case
> the system only detect 2.8G (and Linux too), The probem still there.

Do you have the latest BIOS of your motherboard?
The latest version is 0901 and that version fixes:

"Fix memory remapping function is not working properly issue."

Download from:
http://support.asus.com/download/download_item.aspx?product=1&model=P5B-VM&SLanguage=en-us

Hope that helps,

Wander.
