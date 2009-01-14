Return-Path: <linux-kernel-owner+w=401wt.eu-S1764810AbZANRDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764810AbZANRDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763498AbZANRCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:02:54 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:42363 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763173AbZANRCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:02:53 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18798.6841.172442.17982@stoffel.org>
Date: Wed, 14 Jan 2009 12:02:49 -0500
From: "John Stoffel" <john@stoffel.org>
To: Philippe De Muyter <phdm@macqel.be>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux kernel without file system
In-Reply-To: <20090114093422.GA9771@frolo.macqel>
References: <496DA678.1090701@wpkg.org>
	<20090114093422.GA9771@frolo.macqel>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Philippe" == Philippe De Muyter <phdm@macqel.be> writes:

Philippe> On Wed, Jan 14, 2009 at 09:46:48AM +0100, Tomasz Chmielewski wrote:
>>> I need to design a very small embedded system that must only control
>>> one ethernet port and two serial lines and must fit in a very small flash
>>> memory.  So I thought about replacing the call to /etc/init by my 
>>> application
>>> program and removing all the file-system part of linux.
>>> Is that doable ?
>>> Is there a 'standard' way of doing that ?
>>> The first problem I see is accessing my serial lines.  How could I do that
>>> without using open("/dev/ttySx"), which requires a file system ?
>>> Is there a way to access devices that does not require a file-system ?
>> 
>> You could put everything in initramfs (and embed it in the kernel).

Philippe> Actually, I was thinking about reducing the footprint of my
Philippe> kernel by removing all the fs-related system calls, so the
Philippe> problem is not where the file-system is, but how to access
Philippe> (serial) devices without giving their "/dev/..." name.

Does it have to be linux?  I've been playing with Arduino boards
(http://www.adafruit.com) lately and they have ethernet modules,
serial libraries, etc.  All on a small small chip.  Well, the ethernet
is a daughter board, but they're still pretty small.  

Depends on how general purpose you need to make this device and what
you're trying to accomplish.  Maybe you need to give people a better
idea of what you're trying to do, instead of assuming you need Linux
and trying to shoe-horn it into a really tiny space.

Cheers,
John
