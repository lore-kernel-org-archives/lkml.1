Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbYHOPBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbYHOPBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbYHOPBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:01:05 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:53366 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYHOPBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:01:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=XXvK8sNpZw+xeRt9t/X7PHGdEKXB9E2xFqpY9BgcCMaFn4Mtd0Ig7S73EWlBEAsqEn
         rj2zuCIOc+xAYDE1JVSLyUtQYMFy9Er1sIvJCOu5RztF8jPv4yBrQsv2QvHGUK8cYsjM
         NKefZ4jwcRtcUg0672+gGmQXx+hsAOPLUWPqc=
Message-ID: <19f34abd0808150801m2d117071xf4296054d5853da7@mail.gmail.com>
Date: Fri, 15 Aug 2008 17:01:02 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jason Wessel" <jason.wessel@windriver.com>
Subject: -rc3-gb635ace: oops in kgdbts
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I gave -rc3-gb635ace a spin on my laptop, but it oopses, I think
somewhere in kgdb code. There were several backtraces, but I only got
the last one, and here's what I could write down in a hurry:

beyond end of test on 'singlestep_breakpoint_test' line 13
WARNING: drivers/misc/kgdbts.c:696

backtrace:

run_simple_test
kgdb_put_char
put_packet
kgdb_handle_exception
kgdb_notify
...
__die
die
do_page_fault
error_code
...
init_kgdbts

I'm sorry for the poor report; it happens before netconsole is up and
I have no serial port on the machine. I don't have a camera atm, nor
the time to reboot with delayed printk. I'll try some more later.

My config is defconfig + almost all debugging options + most other
scary options.

Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
