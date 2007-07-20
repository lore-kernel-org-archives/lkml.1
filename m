Return-Path: <linux-kernel-owner+w=401wt.eu-S935175AbXGTIAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935175AbXGTIAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 04:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760468AbXGTIAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 04:00:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43315 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760334AbXGTIAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 04:00:38 -0400
Date: Fri, 20 Jul 2007 00:59:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: drivers/base/core.c broken for non-CONFIG_HOTPLUG
Message-Id: <20070720005958.47cd7c9c.akpm@linux-foundation.org>
In-Reply-To: <20070720070106.GH1678@pengutronix.de>
References: <20070720070106.GH1678@pengutronix.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 09:01:06 +0200 Robert Schwebel <r.schwebel@pengutronix.de> wrote:

> You add and use
> 
> 	extern const char *kobject_actions[];

Added it in a .c file, too.  Even checkpatch.pl knows that
was wrong.
