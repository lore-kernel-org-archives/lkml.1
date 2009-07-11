Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbZGKVxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbZGKVxy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 17:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZGKVxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 17:53:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56540 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZGKVxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 17:53:44 -0400
Date: Sat, 11 Jul 2009 17:53:43 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Pekka Paalanen <pq@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kconfig, Makefile and ifdef: mod as yes vs. no?
Message-ID: <20090711215343.GC31925@bombadil.infradead.org>
References: <20090712000625.7e1bffc2@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090712000625.7e1bffc2@daedalus.pq.iki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 12:06:25AM +0300, Pekka Paalanen wrote:
> +#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
>

You need to test _MODULE for the symbol too... since it's necessary to
be able to distinguish between symbols which exist in the vmlinux, and
symbols which require a module to be loaded.

#if defined(CONFIG_BACKLIGHT_CLASS_DEVICE) &&
	defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE)

should work.

regards, Kyle
