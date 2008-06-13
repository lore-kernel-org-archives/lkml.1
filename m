Return-Path: <linux-kernel-owner+w=401wt.eu-S1761256AbYFMBnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256AbYFMBnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 21:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757992AbYFMBnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 21:43:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:45791 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbYFMBnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 21:43:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eg09BUP9U6fOTV9VqMY4Y3ZOoGk0+FKrZ7ThHZeaWfa9QN6EVham6/+91BFNEPhPgV
         +56n4XQvAKLGG/5iv/wF3CrKrw+AJ2i1dnOwKYy2YiIxrXXBUIsDoAbVnYMJmaCdSqkm
         S8lgvlofv79mW69/60OgDw/XwIHEApCFVhp5I=
Message-ID: <86802c440806121843k221aaed9wc49b3a6a1ea966af@mail.gmail.com>
Date: Thu, 12 Jun 2008 18:43:09 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: kexec@lists.infradead.org, vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Limit E820 map and /proc/iomem for mem parameter on x86-64
In-Reply-To: <20080610215325.GA20673@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080610215325.GA20673@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 2:53 PM, Bernhard Walle <bwalle@suse.de> wrote:
> This patch tries to unify the behaviour of i386 and x86-64 when parsing
> the memory (mem/memmap) parameter of the kernel command line:
>
> On i386, the view was limited (i.e. the actual view was presented).
> On x86-64, the view was full (i.e. the BIOS view was presented).
>
> This patch moves the limit_regions() function and the print_memory_map()
> function to a new file e820.c, shared between the two x86 flavours. Then
> it adds calls to limit_regions() in 64 bit code.
>
> I gave the patch a bit testing. However, it's not for merging, it's just
> to get early feedback to see if that goes into the right direction.

can you check tip/master about that e820 merge?

http://people.redhat.com/mingo/tip.git/readme.txt

it made 32bit using e820_register_active_region...and limit_region in
32bit is remove.

YH
