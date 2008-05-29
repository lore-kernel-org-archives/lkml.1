Return-Path: <linux-kernel-owner+w=401wt.eu-S1758414AbYE2RfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbYE2RfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 13:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbYE2Re7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 13:34:59 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61871 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753720AbYE2Re7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 13:34:59 -0400
Date: Thu, 29 May 2008 18:34:13 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] NTP: Let update_persistent_clock() sleep
In-Reply-To: <20080528201612.d2641dc3.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.55.0805291308000.8254@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805281856200.29522@cliff.in.clinika.pl>
 <20080528201612.d2641dc3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008, Andrew Morton wrote:

> Roman does most of the NTP work afaik.  I consider Thomas's git-hrt
> tree to be the route via which NTP changes get into linux-next and
> mainline.

 Thanks for the clarification.

> OK, that timer code in there now officially makes my brain hurt.

 Ouch, it would be a misery to waste such a perfectly good brain!

> Is it as simple as it could be?
> 
> Would schedule_delayed_work() make my brain feel better?

 Hmm, I have missed this interface somehow.  I am sending an update 
straight away.

  Maciej
