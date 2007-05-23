Return-Path: <linux-kernel-owner+w=401wt.eu-S1760377AbXEWHtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760377AbXEWHtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXEWHs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:48:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60560 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723AbXEWHs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:48:56 -0400
Date: Wed, 23 May 2007 00:48:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-usb-devel@lists.sourceforge.net, Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
Message-Id: <20070523004819.2b3ef22d.akpm@linux-foundation.org>
In-Reply-To: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 00:42:33 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc2/2.6.22-rc2-mm1/

This is intermittently getting resume-from-RAM failures.  It is not
sufficiently repeatable to be able to bisect.

[ 1381.119362] PM: Preparing system for mem sleep
[ 2331.798452] Stopping tasks ... 
[ 2351.760431] Stopping kernel threads timed out after 20 seconds (2 tasks refusing to freeze):
[ 2351.762385]  ksuspend_usbd
[ 2351.764374]  khubd
[ 2351.766338] Restarting tasks ... done.
