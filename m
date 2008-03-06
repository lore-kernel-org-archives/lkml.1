Return-Path: <linux-kernel-owner+w=401wt.eu-S934056AbYCFUu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934056AbYCFUu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbYCFUuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:50:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46681 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796AbYCFUuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:50:20 -0500
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Chris Wedgwood <cw@f00f.org>,
       Pawel Plociennik <paplociennik@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080306115315.GA8972@elf.ucw.cz>
References: <200803060001.38432.paplociennik@gmail.com>
	 <20080306103422.GA5511@puku.stupidest.org> <20080306104448.GG13391@elte.hu>
	 <20080306112212.GA9261@puku.stupidest.org> <20080306113729.GA18403@elte.hu>
	 <20080306115315.GA8972@elf.ucw.cz>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 20:46:21 +0100
Message-Id: <1204832781.6241.269.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-06 at 12:53 +0100, Pavel Machek wrote:
> On Thu 2008-03-06 12:37:29, Ingo Molnar wrote:
> > 
> > * Chris Wedgwood <cw@f00f.org> wrote:
> > 
> > > > But given an existing initrd (which might have come from the distro, 
> > > > etc.) i prefer adding boot options instead of modifying the initrd.
> > > 
> > > I assume this is so you have have /distro1 /distro2 and use your boot
> > > option to (help) select which one you boot into?
> > 
> > while i have no personal use for chroot=, i generally test distros that 
> > way, yes - and i try to keep them as unmodified as possible.
> > 
> > "Use the initrd as an extended boot commandline" is a poor answer IMO. 
> > 
> > _Everything_ we do on the boot commandline that affects user-space can 
> > be done in an initrd in theory - but still we have hundreds of boot 
> > options.
> 
> Yes, please. chroot= is useful, nonintrusive, and it just should be there.

As much as I hate initrd, and all features building dependencies on it,
I don't see the need for either initrd or kernel support for chroot= as
it can be trivially done using a slightly longer init=.

