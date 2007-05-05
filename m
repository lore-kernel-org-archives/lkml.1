Return-Path: <linux-kernel-owner+w=401wt.eu-S934032AbXEEWG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032AbXEEWG6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 18:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934038AbXEEWG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 18:06:58 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:34485 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934032AbXEEWG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 18:06:58 -0400
Date: Sun, 6 May 2007 00:06:54 +0200
From: Bernd Schubert <bs@q-leap.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       bernd-schubert@gmx.de
Subject: Re: mkfs.ext2 triggerd RAM corruption
Message-ID: <20070505220654.GA26879@lanczos.q-leap.de>
References: <200705041659.51675.bs@q-leap.de> <20070504184943.GC25339@thunk.org> <20070505013637.GA23803@lanczos.q-leap.de> <20070505185735.GB21049@thunk.org> <Pine.LNX.4.61.0705052111440.18504@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705052111440.18504@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 09:12:02PM +0200, Jan Engelhardt wrote:
> 
> On May 5 2007 14:57, Theodore Tso wrote:
> >On Sat, May 05, 2007 at 03:36:37AM +0200, Bernd Schubert wrote:
> >> distribution: modified debian sarge, in which aspect is the distribution
> >> important for this problem? mkfs2.ext2 is supposed to write to /dev/sdaX
> >> and not /dev/rd/0. Stracing it and grepping for open calls shows that
> >> only /dev/sdaX is opened in read-write mode.
> >
> >/dev/rd/0?  What's this?
> 
> devfs (hint hint) naming for /dev/ram0.

Yep, but udev knows devfs style ... (I already told I tested vanilla
kernels, so no patches).

Bernd
