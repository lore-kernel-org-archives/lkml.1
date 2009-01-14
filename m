Return-Path: <linux-kernel-owner+w=401wt.eu-S1761517AbZANKVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761517AbZANKVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbZANKVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:21:32 -0500
Received: from smtp2a.orange.fr ([80.12.242.138]:44155 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010AbZANKVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:21:31 -0500
X-Greylist: delayed 1736 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2009 05:21:31 EST
X-ME-UUID: 20090114095234413.0A15F7000081@mwinf2a03.orange.fr
Subject: Re: linux kernel without file system
From: Xavier Bestel <xavier.bestel@free.fr>
To: Philippe De Muyter <phdm@macqel.be>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090114093422.GA9771@frolo.macqel>
References: <496DA678.1090701@wpkg.org> <20090114093422.GA9771@frolo.macqel>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 10:52:24 +0100
Message-Id: <1231926744.11907.12.camel@skunk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2009-01-14 at 10:34 +0100, Philippe De Muyter wrote:
> On Wed, Jan 14, 2009 at 09:46:48AM +0100, Tomasz Chmielewski wrote:
> >> I need to design a very small embedded system that must only control
> >> one ethernet port and two serial lines and must fit in a very small flash
> >> memory.  So I thought about replacing the call to /etc/init by my 
> >> application
> >> program and removing all the file-system part of linux.
> >> Is that doable ?
> >> Is there a 'standard' way of doing that ?
> >> The first problem I see is accessing my serial lines.  How could I do that
> >> without using open("/dev/ttySx"), which requires a file system ?
> >> Is there a way to access devices that does not require a file-system ?
> >
> > You could put everything in initramfs (and embed it in the kernel).
> 
> Actually, I was thinking about reducing the footprint of my kernel by
> removing all the fs-related system calls, so the problem is not where
> the file-system is, but how to access (serial) devices without giving their
> "/dev/..." name.

You can still mount sysfs somewhere and access the device nodes from
there.

	Xav


