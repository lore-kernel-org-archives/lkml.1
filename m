Return-Path: <linux-kernel-owner+w=401wt.eu-S1030781AbXDLXiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030781AbXDLXiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030801AbXDLXiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:38:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:38074 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030781AbXDLXiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:38:04 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH UPDATE] deflate stack usage in lib/inflate.c
Date: Fri, 13 Apr 2007 01:37:57 +0200
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tim Yamin <plasmaroo@gentoo.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <461DED14.1070603@goop.org> <461EB515.4080106@goop.org> <Pine.LNX.4.61.0704130119470.14441@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704130119470.14441@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704130137.57323.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 April 2007 01:20:40 Jan Engelhardt wrote:
> 
> On Apr 12 2007 15:39, Jeremy Fitzhardinge wrote:
> >Andi Kleen wrote:
> >> Hmm, does Xen perhaps not use interrupt stacks? Normally 2.7k should be still
> >> green as long as there are not too many functions above/below it.
> >
> >That's a good point, I'll need to check that.  Still, nearly 3k of stack!
> 
> I bite. Would compressing the vmlinux binary with LZO or LZMA make an
> improvement to the bootstrap uncompress stack usage?

We don't care about the stack usage, as long as it doesn't overflow.
It's a very limited piece of code that doesn't run on top or below
other subsystems.

-Andi
