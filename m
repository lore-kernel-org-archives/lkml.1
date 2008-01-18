Return-Path: <linux-kernel-owner+w=401wt.eu-S932381AbYARWNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbYARWNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761432AbYARWNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:13:04 -0500
Received: from ozlabs.org ([203.10.76.45]:33246 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757611AbYARWND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:13:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/3] Improve type handling in interrupt handlers
Date: Sat, 19 Jan 2008 09:11:14 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ash Willis <ashwillis@programmer.net>, linux-pcmcia@lists.infradead.org
References: <200801190722.26154.rusty@rustcorp.com.au> <47910F05.8040501@pobox.com>
In-Reply-To: <47910F05.8040501@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801190911.15106.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2008 07:41:41 Jeff Garzik wrote:
> You should be using irq_handler_t for all these.

Well, these are your drivers, but for mine I dislike the obfuscation.

It's not like you can declare the function itself to be an irq_handler_t, so 
it's a strange turd to drop in a driver.

> (Coincedentally, doing so makes it easier for me to later on remove the 
> almost-never-used 'irq' argument from all irq handlers)

Slightly, but the compiler would tell you if you miss one, so I don't think 
this is real.

Cheers,
Rusty.
