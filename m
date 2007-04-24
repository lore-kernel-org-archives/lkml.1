Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbXDXK3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbXDXK3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 06:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbXDXK3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 06:29:06 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754612AbXDXK3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 06:29:05 -0400
Date: Tue, 24 Apr 2007 03:28:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH -mm 3/3] PM: Introduce suspend notifiers (rev. 2)
Message-Id: <20070424032835.5b102d1a.akpm@linux-foundation.org>
In-Reply-To: <200704222048.08911.rjw@sisk.pl>
References: <200704222010.21999.rjw@sisk.pl>
	<200704222048.08911.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2007 20:48:08 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Make it possible to register suspend notifiers so that subsystems can perform
> suspend-related operations that should not be carried out by device drivers'
> .suspend() and .resume() routines.

x86_64 allnoconfig:

arch/x86_64/kernel/e820.c: In function 'e820_mark_nosave_regions':
arch/x86_64/kernel/e820.c:279: warning: implicit declaration of function 'register_nosave_region'
arch/x86_64/kernel/built-in.o: In function `e820_mark_nosave_regions':
: undefined reference to `register_nosave_region'
arch/x86_64/kernel/built-in.o: In function `e820_mark_nosave_regions':
: undefined reference to `register_nosave_region'
