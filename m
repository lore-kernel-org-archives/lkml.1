Return-Path: <linux-kernel-owner+w=401wt.eu-S1762408AbXGTNa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762408AbXGTNa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 09:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756496AbXGTNav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 09:30:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:55046 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbXGTNau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 09:30:50 -0400
Subject: Re: drivers/base/core.c broken for non-CONFIG_HOTPLUG
From: Kay Sievers <kay.sievers@vrfy.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20070720005958.47cd7c9c.akpm@linux-foundation.org>
References: <20070720070106.GH1678@pengutronix.de>
	 <20070720005958.47cd7c9c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 14:06:19 +0200
Message-Id: <1184933179.3545.12.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19F+5Qz4wyEuVy1VXgjcr0zsp/MFBLVO6MgKL5
 wGSZs8EwaxxnKtjaXOXLnky0Q6tnUADEvCV8RdXvoPB44P8Q3I
 RxzUpNgRvyhYtBUACGTAg8L5tOkhNTC
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 00:59 -0700, Andrew Morton wrote:
> On Fri, 20 Jul 2007 09:01:06 +0200 Robert Schwebel <r.schwebel@pengutronix.de> wrote:
> 
> > You add and use
> > 
> > 	extern const char *kobject_actions[];
> 
> Added it in a .c file, too.  Even checkpatch.pl knows that
> was wrong.

The kernel is doing that all over the place for global symbols that are
not meant to be used out of a "private" context or where a "private"
header file of a subsystem doesn't exist.

I can change that, if this isn't the way to do it?

Thanks,
Kay

