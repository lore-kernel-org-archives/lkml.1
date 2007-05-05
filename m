Return-Path: <linux-kernel-owner+w=401wt.eu-S933152AbXEETMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbXEETMv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 15:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbXEETMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 15:12:51 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:47872 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933152AbXEETMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 15:12:50 -0400
Date: Sat, 5 May 2007 21:12:02 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Theodore Tso <tytso@mit.edu>
cc: Bernd Schubert <bs@q-leap.de>, linux-kernel@vger.kernel.org
Subject: Re: mkfs.ext2 triggerd RAM corruption
In-Reply-To: <20070505185735.GB21049@thunk.org>
Message-ID: <Pine.LNX.4.61.0705052111440.18504@yvahk01.tjqt.qr>
References: <200705041659.51675.bs@q-leap.de> <20070504184943.GC25339@thunk.org>
 <20070505013637.GA23803@lanczos.q-leap.de> <20070505185735.GB21049@thunk.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 5 2007 14:57, Theodore Tso wrote:
>On Sat, May 05, 2007 at 03:36:37AM +0200, Bernd Schubert wrote:
>> distribution: modified debian sarge, in which aspect is the distribution
>> important for this problem? mkfs2.ext2 is supposed to write to /dev/sdaX
>> and not /dev/rd/0. Stracing it and grepping for open calls shows that
>> only /dev/sdaX is opened in read-write mode.
>
>/dev/rd/0?  What's this?

devfs (hint hint) naming for /dev/ram0.


Jan
-- 
