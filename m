Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbXDLXXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbXDLXXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbXDLXXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:23:36 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:54111 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbXDLXXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:23:35 -0400
Date: Fri, 13 Apr 2007 01:20:40 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Tim Yamin <plasmaroo@gentoo.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH UPDATE] deflate stack usage in lib/inflate.c
In-Reply-To: <461EB515.4080106@goop.org>
Message-ID: <Pine.LNX.4.61.0704130119470.14441@yvahk01.tjqt.qr>
References: <461DED14.1070603@goop.org> <461E9BAD.8050202@goop.org>
 <200704122321.23318.ak@suse.de> <461EB515.4080106@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 12 2007 15:39, Jeremy Fitzhardinge wrote:
>Andi Kleen wrote:
>> Hmm, does Xen perhaps not use interrupt stacks? Normally 2.7k should be still
>> green as long as there are not too many functions above/below it.
>
>That's a good point, I'll need to check that.  Still, nearly 3k of stack!

I bite. Would compressing the vmlinux binary with LZO or LZMA make an
improvement to the bootstrap uncompress stack usage?


Jan
-- 
