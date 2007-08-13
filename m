Return-Path: <linux-kernel-owner+w=401wt.eu-S965411AbXHMDib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965411AbXHMDib (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 23:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935632AbXHMDiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 23:38:24 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:45812 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935620AbXHMDiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 23:38:23 -0400
Date: Sun, 12 Aug 2007 20:38:22 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [1/12] x86: Work around mmio config space quirk on AMD
 Fam10h
In-Reply-To: <alpine.LFD.0.999.0708122021300.30176@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708122037140.31985@twinlark.arctic.org>
References: <20070809241.425881000@suse.de> <20070809124128.886BE14F3B@wotan.suse.de>
 <alpine.LFD.0.999.0708120216470.30176@woody.linux-foundation.org>
 <200708121203.23741.ak@suse.de> <alpine.LFD.0.999.0708121205210.30176@woody.linux-foundation.org>
 <20070813030632.GA1445@redhat.com> <alpine.LFD.0.999.0708122021300.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007, Linus Torvalds wrote:

> On Sun, 12 Aug 2007, Dave Jones wrote:
> > 
> > This does make me wonder, why these weren't caught in -mm ?
> 
> I'm worried that -mm isn't getting a lot of exposure these days. People do 
> run it, but I wonder how many..

andrew caught it in -mm and reverted it.  it crashed his vaio.

-dean
