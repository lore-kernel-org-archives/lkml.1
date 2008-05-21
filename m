Return-Path: <linux-kernel-owner+w=401wt.eu-S1764465AbYEUXMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764465AbYEUXMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbYEUXLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:11:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757162AbYEUXLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:11:52 -0400
Date: Wed, 21 May 2008 16:11:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: cooloney@kernel.org, linux-kernel@vger.kernel.org,
       michael.hennerich@analog.com
Subject: Re: +
 pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2.patch added to
 -mm tree
Message-Id: <20080521161137.ed4bd6cf.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0805201741h13e44c4dkead97118d7d137e8@mail.gmail.com>
References: <200805200608.m4K68d0N008092@imap1.linux-foundation.org>
	<386072610805200051tcbf2d1bpcb981749c16879b6@mail.gmail.com>
	<20080520010223.5e55d074.akpm@linux-foundation.org>
	<8bd0f97a0805201741h13e44c4dkead97118d7d137e8@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 20:41:13 -0400
"Mike Frysinger" <vapier.adi@gmail.com> wrote:

> > This:
> >
> >> -#if defined(__arm__) || defined(__mips__) || defined(__avr32__)
> >> +#if defined(__arm__) || defined(__mips__) || defined(__avr32__) || defined(bfin)
> >
> > should probably be using CONFIG_foo but that might not work if it's to
> > be preprocessed by userspace.  I didn't look.  Plus that'd be
> > off-topic.
> 
> it should be defined(__bfin__) at least.

Well I made that change, but this all has a rather untested feeling to
it.

