Return-Path: <linux-kernel-owner+w=401wt.eu-S1764378AbYEUWTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764378AbYEUWTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756447AbYEUWTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:19:06 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64490 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754289AbYEUWTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:19:05 -0400
Date: Wed, 21 May 2008 23:18:32 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Philippe De Muyter <phdm@macqel.be>
cc: linux-kernel@vger.kernel.org
Subject: Re: RTC subsystem and 11 min rtc update
In-Reply-To: <20080521215751.GA12343@frolo.macqel>
Message-ID: <Pine.LNX.4.55.0805212311130.4894@cliff.in.clinika.pl>
References: <20080520105844.GA694@frolo.macqel> <18482.45473.866954.385654@cargo.ozlabs.ibm.com>
 <20080520140744.GA6427@frolo.macqel> <20080521215751.GA12343@frolo.macqel>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Philippe De Muyter wrote:

> Should update_persistent_clock not be directly part of the rtc subsystem,
> instead of falling in a detour or a dead-end in the arch subsystem ?

 See the recent discussion around my proposal:

http://www.ussg.iu.edu/hypermail/linux/kernel/0805.1/1772.html

I am about to update some of the architecture bits in arch/mips/sibyte,
but otherwise the patchset is ready to go.  Feel free to join the
discussion and/or update your platform to make use of the generic
rtc_read_persistent_clock() and rtc_update_persistent_clock() functions.  
Testing is always welcome too.

  Maciej
