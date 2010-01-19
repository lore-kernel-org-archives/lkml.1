Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617Ab0ASQjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab0ASQjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 11:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593Ab0ASQjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 11:39:12 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:63376 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab0ASQjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 11:39:09 -0500
Date: Tue, 19 Jan 2010 08:38:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Phillip Lougher <phillip.lougher@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, albin.tonnerre@free-electrons.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: linux-next: Tree for January 12 (unlzo)
Message-Id: <20100119083839.4b5dfb1b.randy.dunlap@oracle.com>
In-Reply-To: <bffbecbb1001121626j61fab30aj87048a17a2b091ff@mail.gmail.com>
References: <20100112171739.2011a0eb.sfr@canb.auug.org.au>
	<20100112083013.1dad8a8d.randy.dunlap@oracle.com>
	<20100113102254.332dbf33.sfr@canb.auug.org.au>
	<bffbecbb1001121626j61fab30aj87048a17a2b091ff@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B55E01F.0152:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 00:26:56 +0000 Phillip Lougher wrote:

> On Tue, Jan 12, 2010 at 11:22 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Randy,
> >
> > On Tue, 12 Jan 2010 08:30:13 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >>
> >> arch/x86/boot/compressed/../../../../lib/decompress_unlzo.c:53: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'parse_header'
> >> arch/x86/boot/compressed/../../../../lib/decompress_unlzo.c:90: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'unlzo'
> >>
> >> Problem is the "INIT" there, seems to be undefined.
> >
> > Caused by an interaction between Linus' tree and the squashfs tree that
> > is being worked on.  It should not occur with today's linux-next as the
> > squashfs changes have been removed pending a fix.
> 
> This problem is caused by the introduction of the unlzo code in Linus'
> tree, and some patches in
> the squashfs-next tree that move things out of
> include/linux/decompress/mm.h into separate
> xxx_mm.h files for each decompressor.  These parches were, obviously,
> done before the unlzo
> code was present.
> 
> I've fixed the patches in the squashfs-next tree for unlzo, and the
> breakage should be fixed :-)


linux-next-20100119 .. still happening.

---
~Randy
