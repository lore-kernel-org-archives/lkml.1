Return-Path: <linux-kernel-owner+w=401wt.eu-S935276AbXGZSMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935276AbXGZSMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761173AbXGZSMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:12:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49883 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760643AbXGZSML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:12:11 -0400
Message-ID: <46A8E3F9.5070809@zytor.com>
Date: Thu, 26 Jul 2007 11:12:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: bbpetkov@yahoo.de
CC: Xudong Guan <xudong.guan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1: no setup signature found...
References: <20070724112618.GA4431@gollum.tnic> <20070726150854.GA7034@xguan-laptop> <46A8BB6C.6050903@zytor.com> <20070726163053.GA4570@gollum.tnic>
In-Reply-To: <20070726163053.GA4570@gollum.tnic>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> 
>> What distro/version of grub are you running?  
> Debian unstable
>> I'm wondering if there are
>> some old version of grub out there which did the "load four sectors"
>> way-anciently-obsolete crap; the other possibility that comes to mind is
>> setting up the stack in an invalid manner.
> grub version:
> 
> [boris@gollum:18:17:27:->  apt-cache show grub
> Package: grub
> Priority: optional
> Section: admin
> Installed-Size: 708
> Maintainer: Grub Maintainers <pkg-grub-devel@lists.alioth.debian.org>
> Architecture: i386
> Version: 0.97-29
> Depends: libc6 (>= 2.5-5), libncurses5 (>= 5.4-5)
> Suggests: grub-doc, mdadm
> Filename: pool/main/g/grub/grub_0.97-29_i386.deb
> Size: 366884
> MD5sum: 2da7a5942db06eaba046dff4615bcce9
> SHA1: 7f4da793da209d011ce94fceebaebe0e5f08790f
> SHA256: 2596782c08f1f7365e9935f687fef74c67d8702503188f22448db9f0ac98e18e
> Description: GRand Unified Bootloader
> ...

This concerns me deeply.  This is a current version of Grub which
shouldn't have any silly 8K limitations.  Yet it appears to have a
similar pathology over the ancient version Xudong just described.

The absolute best would be if we could replicate this in simulation
(Bochs or Qemu); this would make it very simple to debug.  Would you be
willing to try to do that?

	-hpa

