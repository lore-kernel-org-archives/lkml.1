Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbXFNW6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbXFNW6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXFNW6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:58:40 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:11755 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbXFNW6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:58:39 -0400
Subject: Re: 2.6.22-rc4-mm2 - usb-storage
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, mdharm-usb@one-eyed-alien.net,
       linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
In-Reply-To: <4671C588.8030507@goop.org>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
	 <1181230628.7348.266.camel@twins>  <4671C588.8030507@goop.org>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 00:58:13 +0200
Message-Id: <1181861893.11113.0.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-14 at 15:47 -0700, Jeremy Fitzhardinge wrote:

> I got the same thing when I plugged my PSP in.

> After this the USB subsystem seems dead.  For example, lsusb hangs in:

Like Alan said, reverting this one fixes it:

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/broken-out/usb-try-to-debug-bug-8561.patch


