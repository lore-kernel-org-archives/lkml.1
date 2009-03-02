Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbZCBNQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbZCBNQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 08:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbZCBNQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 08:16:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:53743 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbZCBNQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 08:16:28 -0500
Subject: Re: lockdep and threaded IRQs (was: ...)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Brownell <david-b@pacbell.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com
In-Reply-To: <200903011454.22280.david-b@pacbell.net>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	 <200902281405.42080.david-b@pacbell.net>
	 <alpine.LFD.2.00.0903011035360.29264@localhost.localdomain>
	 <200903011454.22280.david-b@pacbell.net>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 14:16:12 +0100
Message-Id: <1235999772.5330.368.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-01 at 14:54 -0800, David Brownell wrote:
> The main "complaint" is the pre-existing lockdep breakage.  :)

Right, I just send a patch to fix that, by simply fixing !lockdep to do
as lockdep does :-)

IRQF_DISABLED is bonkers, we should simply always disable interrupts for
interrupt handlers.

The only problem you have is your of your own tinkering.



