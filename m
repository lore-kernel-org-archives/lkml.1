Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbYEMWEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbYEMWEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 18:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbYEMWDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 18:03:52 -0400
Received: from laska.dorms.spbu.ru ([195.19.252.72]:50137 "EHLO
	laska.dorms.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbYEMWDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 18:03:51 -0400
Date: Wed, 14 May 2008 02:03:44 +0400
From: Mikhail Kshevetskiy <kl@laska.dorms.spbu.ru>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.25: early exception 0e
Message-ID: <20080514020344.4ba74b44@laska>
In-Reply-To: <Pine.LNX.4.64.0805131134350.11363@jikos.suse.cz>
References: <20080510105712.74f17c01@laska>
	<Pine.LNX.4.64.0805121221480.30585@twin.jikos.cz>
	<20080512212154.788ba5a1@laska>
	<Pine.LNX.4.64.0805131134350.11363@jikos.suse.cz>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 11:35:14 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Mon, 12 May 2008, Mikhail Kshevetskiy wrote:
> 
> > > > PANIC: early exception 0e rip 10:ffffffff80224b4e error 0 cr2
> > > > ffffffffff5fb030
> > > There should be a stack trace following this message, please post it (we 
> > > need to know what function does 0xffffffff80224b4e correspond to, at 
> > > least).
> > There is nothing more on the screen, just this single line. I try to 
> > enable more kernel debug options, maybe this helps.
> 
> Or you could use addr2line utility to at least see what function does 
> 0xffffffff80224b4e correspond to.


kl@aspid:/usr/src/linux-2.6.25.3$ addr2line -Cfe vmlinux ffffffff80224b4e
native_apic_read
paravirt.c:0

if this help, I can send you kernel image and kernel configuration.

Mikhail Kshevetskiy
