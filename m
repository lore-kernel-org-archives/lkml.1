Return-Path: <linux-kernel-owner+w=401wt.eu-S1760964AbZFLL50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964AbZFLL50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZFLL5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:57:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59161 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755379AbZFLL5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:57:18 -0400
Date: Fri, 12 Jun 2009 12:56:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] Blackfin: sync termios header changes with x86
Message-ID: <20090612125643.00bf36d4@lxorguk.ukuu.org.uk>
In-Reply-To: <1244804202-17030-1-git-send-email-vapier@gentoo.org>
References: <200906121247.50745.arnd@arndb.de>
	<1244804202-17030-1-git-send-email-vapier@gentoo.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -#define FIOQSIZE	0x545E
> +#define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
> +#define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
> +#define FIOQSIZE	0x5460

Umm.. probably better to leave FIOQSIZE where it is ;)

The HAYES ones are obsolete for a specific ancient ISA bus driver so can
probably just be left off

