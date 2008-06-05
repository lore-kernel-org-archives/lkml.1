Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbYFENyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbYFENyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 09:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYFENyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 09:54:45 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:55390 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbYFENyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 09:54:44 -0400
Date: Thu, 5 Jun 2008 15:54:15 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Felipe Balbi <felipebalbi@users.sourceforge.net>
Subject: Re: [patch 2.6.26-rc4] add HAVE_CLK to Kconfig, for driver
 dependencies
Message-ID: <20080605155415.3b3f503a@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200805291156.51933.david-b@pacbell.net>
References: <200805291156.51933.david-b@pacbell.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jun 2008 13:53:40.0306 (UTC) FILETIME=[8F54BB20:01C8C713]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> This patch flags platforms as HAVE_CLK (or not) in Kconfig,
> so that otherwise portable drivers which need those calls
> can list that dependency.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Great idea! This will allow us to clean up some of the dependency mess
in the shared AVR32/AT91 drivers and get better compile-testing
coverage.

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
