Return-Path: <linux-kernel-owner+w=401wt.eu-S1764350AbYARWyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764350AbYARWyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761186AbYARWy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:54:28 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:52980 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761288AbYARWy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:54:28 -0500
Message-ID: <47912E1F.3020302@pobox.com>
Date: Fri, 18 Jan 2008 17:54:23 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ash Willis <ashwillis@programmer.net>, linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH 1/3] Improve type handling in interrupt handlers
References: <200801190722.26154.rusty@rustcorp.com.au> <47910F05.8040501@pobox.com> <200801190911.15106.rusty@rustcorp.com.au>
In-Reply-To: <200801190911.15106.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Saturday 19 January 2008 07:41:41 Jeff Garzik wrote:
>> You should be using irq_handler_t for all these.
> 
> Well, these are your drivers, but for mine I dislike the obfuscation.
> 
> It's not like you can declare the function itself to be an irq_handler_t, so 
> it's a strange turd to drop in a driver.

The others need to be irq_handler_t because that's the precise type 
that's being used in each particularly situation.  Each time the code 
re-creates that definition creates a problem for future irq handler 
changes of any type, really.

As I noted, I've fixed all this crap already, and read through each one 
of those drivers.

	Jeff



