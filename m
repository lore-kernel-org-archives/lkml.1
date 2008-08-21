Return-Path: <linux-kernel-owner+w=401wt.eu-S1761067AbYHUTc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761067AbYHUTc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 15:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbYHUTcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 15:32:16 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:5783 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbYHUTcO (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 15:32:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hNQ1Ir0ayHGfb+KCKZ+H6/gg+MkQvyAlvelnczqTLFAy5i8kyA+f3DovJpjzew6i09
         +/1TK/ht4ME2eXK87jkma92px8qrnTik/3478FU81oM9lbzSuvy5opyGFgUOxr11uH/L
         p3vZedbyaVeRni5AvaunG0LrCuQoRgAGr9ySI=
Message-ID: <6934efce0808211232i21fcf347vb6baa6502246adb2@mail.gmail.com>
Date: Thu, 21 Aug 2008 12:32:13 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <ac9c93b10808202332n2654884eh877848df2da59f20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00C4.6060302@gmail.com>
	 <ac9c93b10808202332n2654884eh877848df2da59f20@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jared, nice work!

Thanks.

> A few questions:

I meant to address these before.  Sorry.

> - how does this benchmark compared to cramfs and squashfs in a NAND-only system
>  (or is it just not a good plan to use this with NAND-only (of course
> I won't get XIP with NAND, I understand that)

I don't know, I'm interested to find out.  I just benchmarked that.
Actually it should work very well as a NAND-only fs.  Also you do get
something like XIP with NAND.  If you boot an XIP AXFS image on NAND
or a blkdev it will copy that XIP region into RAM and "XIP" it from
there.  I think this will make it very good for LiveCD's.  Though we
just (minutes ago) realized our testing of that feature was flawed, so
no guarantees.

> - would axfs be suitable as a filesystem on a ram disk?

It could be.  I plan on implementing support for brd.  That might work nicely.
