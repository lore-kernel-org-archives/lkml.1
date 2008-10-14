Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbYJNEfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbYJNEfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 00:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYJNEfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 00:35:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:41333 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYJNEfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 00:35:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pNVggk3uNtVw01WjkWe6zpc7jPz/QCn836JQLglS0cjyQ0q1U4arKzbs/xSxaOX262
         b442tbLQI6dWDqHSQmuBWfSUIVm+c/cNgPEBGZjeoQ/MYd7pDe+Cqu41tBCAzS7YN0FU
         77i/2yCB44o1qB6r1M5C7sganGjmW0wc7Chlg=
Message-ID: <19f34abd0810132135i4f3d30j1df6997fc08d1ae3@mail.gmail.com>
Date: Tue, 14 Oct 2008 06:35:00 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pete Clements" <clem@clem.clem-digital.net>
Subject: Re: 27-git2,3,4 panics on boot
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200810140145.m9E1jsFF001817@clem.clem-digital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810140145.m9E1jsFF001817@clem.clem-digital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 3:45 AM, Pete Clements
<clem@clem.clem-digital.net> wrote:
> Fyi, x86 pentium III, uniprocessor, panics as soon as
> it starts the boot up.  Output scrolls off screen, here is
> the partial call list remaining of screen:
>
> vprintk
...
> printk
> __reserve_region_with_split
> e820_reserve_resources_late
> pcibios_init

Hi,

Thanks for the report. This is probably also a case of a known error,
see this thread: http://lkml.org/lkml/2008/9/4/386

It should be fixed in mainline soon.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
