Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbYHaCRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbYHaCRr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 22:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbYHaCRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 22:17:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:7386 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbYHaCRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 22:17:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=clFYkTnhJ6WBKxtGJ3+vEbfBLFhs9i2rD0+NnOcgaISuMQMejP1YUVDTEtreREHN4g
         0r2fRQUJuDEOpjjit4HvD24DLbpAQcsAUwEuNCeJc0EbuBhsIdxCYbmWQFfeqlaqR4M3
         tL33hFb57EwXhSGAd4W+bnWC4vUofy295YTmA=
Message-ID: <86802c440808301917n67d2fb34k96137829a49d36ac@mail.gmail.com>
Date: Sat, 30 Aug 2008 19:17:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <349034.72587.qm@web82104.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <349034.72587.qm@web82104.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 6:25 PM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>
>
>> please use split_e820_reserve_xx2.patch instead...
>
> OK, that produces the same result:  a happy kernel!
>
> I compared the full 'dmesg' output from the previous build and the
> current build using diff:  the only differences were trivial --
> return times from initcall functions, and the order in which some
> initcalls were performed was different very late in the boot process.

good, let wait for Ingo back to check the two patches too.

YH
