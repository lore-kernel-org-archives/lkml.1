Return-Path: <linux-kernel-owner+w=401wt.eu-S1763236AbZFMQNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763236AbZFMQNb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbZFMQNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 12:13:24 -0400
Received: from mail2.shareable.org ([80.68.89.115]:49546 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbZFMQNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 12:13:24 -0400
Date: Sat, 13 Jun 2009 17:13:23 +0100
From: Jamie Lokier <jamie@shareable.org>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: linux-kernel@vger.kernel.org, Jie Zhang <jie.zhang@analog.com>,
       Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
Subject: Re: [uClinux-dev] [PATCH/RFC] FDPIC: add hook for arches to customize program header parsing
Message-ID: <20090613161323.GC16220@shareable.org>
References: <1244854869-2563-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244854869-2563-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> From: Jie Zhang <jie.zhang@analog.com>
> 
> The Blackfin port has custom program header flags/addresses for
> automatically loading regions into the dedicated on-chip SRAM.  So add a
> hook for ports to leverage.

What does this have to do with FDPIC?  I don't see anything that is
specific to FDPIC about this code, other than FDPIC being the type of
ELF used on Blackfin.  If an MMU were added to some future Blackfins,
wouldn't this code be used for non-FDPIC ELF too?

It looks like a way for certain special executables to load themselves
into fixed regions of the on-chip SRAM - and promptly crash if another
executable does the same.  Not so much a general executable format, as
a hack to load something specific which should only be done once at a
time.  What am I missing here?

-- Jamie
