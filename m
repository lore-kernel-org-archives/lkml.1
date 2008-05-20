Return-Path: <linux-kernel-owner+w=401wt.eu-S1762082AbYETIDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762082AbYETIDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759773AbYETIDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:03:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758553AbYETIDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:03:04 -0400
Date: Tue, 20 May 2008 01:02:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Bryan Wu" <cooloney@kernel.org>
Cc: linux-kernel@vger.kernel.org, michael.hennerich@analog.com
Subject: Re: +
 pcmcia-add-support-the-cf-pcmcia-driver-for-blackfin-try-2.patch added to
 -mm tree
Message-Id: <20080520010223.5e55d074.akpm@linux-foundation.org>
In-Reply-To: <386072610805200051tcbf2d1bpcb981749c16879b6@mail.gmail.com>
References: <200805200608.m4K68d0N008092@imap1.linux-foundation.org>
	<386072610805200051tcbf2d1bpcb981749c16879b6@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 15:51:13 +0800 "Bryan Wu" <cooloney@kernel.org> wrote:
>

eek, scary top-posting.

> Need I resend out the a new patch which fold these 3 patches together.
> it is easier for you to maintain.

Nope,  I keep the patches separate and then fold them prior to sending
to Linus.

I marked this as for-2.6.26 as it's clearly non-injurious to existing stuff.

This:

> -#if defined(__arm__) || defined(__mips__) || defined(__avr32__)
> +#if defined(__arm__) || defined(__mips__) || defined(__avr32__) || defined(bfin)

should probably be using CONFIG_foo but that might not work if it's to
be preprocessed by userspace.  I didn't look.  Plus that'd be
off-topic.

