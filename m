Return-Path: <linux-kernel-owner+w=401wt.eu-S1161025AbXBZU41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161025AbXBZU41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 15:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161029AbXBZU41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 15:56:27 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:44627 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161025AbXBZU40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 15:56:26 -0500
Message-ID: <45E3493C.1040706@gmail.com>
Date: Mon, 26 Feb 2007 21:55:24 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>, Stephane Eranian <eranian@hpl.hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot
 be mounted without hanging up the whole system
References: <20070226180635.GA644@tv-sign.ru> <Pine.LNX.4.64.0702261006440.12485@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702261006440.12485@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2007 07:13 PM, Linus Torvalds wrote:

> The floppy is still pretty much the only user of native motherboard
> (aka i8237) DMA'ing for most people. Some old ISA sound-cards may do
> it, of course.

Other than these two, ECP parallel ports are the other remaining users.
Now, even though on a machine that still has a parallel port it might 
usually indeed be set to ECP in its BIOS; having anything attached to 
the port also use it as such seems quite seldom.

Rene.
