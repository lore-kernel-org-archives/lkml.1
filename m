Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbYHXIXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbYHXIXl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 04:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYHXIXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 04:23:24 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:55197 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbYHXIXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 04:23:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=o5pASknCNsd1HLVFfi7KcJNEsvfe4GqOZt6yni1gM6eF8WNm3+nASaVsJ4D/PfWj1o
         gg2/bu6x42KaZYyHF5ynxaa6S2Y1bNqR93ctdk/D70ll2/WT3O4+vgzPSPz0hd3ZFvlJ
         cQsAryqDWnXUCrTHKYA+IzWjQZCswhv+hCQgk=
Message-ID: <19f34abd0808240123r3d5a7b61w5a35da15f6e5ef14@mail.gmail.com>
Date: Sun, 24 Aug 2008 10:23:19 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: 9a2d43b: __alloc_bootmem_core(): zero-sized request
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0808240058h3d286151x18cba0939f175edd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808221224s4674e5aaq34bd0a874dfba699@mail.gmail.com>
	 <87myj4yzll.fsf@skyscraper.fehenstaub.lan>
	 <19f34abd0808240058h3d286151x18cba0939f175edd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 9:58 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Inserted a printk("nr_kernel_pages = %llu\n", nr_kernel_pages); and
> this is the output:
>
> nr_kernel_pages = 13869392367443771392

Also written as 0xc079fae000000000. Of which the upper 32 bits
"coincidentally" matches that of a symbol:

c079fae0 d mutex_Z2

But the significance eludes me...


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
