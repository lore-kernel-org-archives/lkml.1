Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbYBHX4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbYBHX4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYBHX41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:56:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38476 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983AbYBHX4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:56:25 -0500
Date: Fri, 8 Feb 2008 15:54:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Dmitry Torokhov <dtor@insightbb.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] [git pull] Input updates for 2.6.25-rc0
Message-Id: <20080208155459.fdbcf610.akpm@linux-foundation.org>
In-Reply-To: <20080208153741.54409a7a.randy.dunlap@oracle.com>
References: <200802060108.31644.dtor@insightbb.com>
	<20080208232536.GA15727@elte.hu>
	<20080208152812.2bb14374@extreme>
	<20080208153741.54409a7a.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008 15:37:41 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > I think someone already sent a patch to select the LEDS
> 
> I did... and more.  Who will merge it?  (below)
> 
> ---
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add I2C to config since the driver makes several i2c*() calls.
> 
> Add to help text that the Intel I2C ICH (i801) driver is also needed
> for this kernel.
> 
> Add LEDS_CLASS to config since the driver makes les_classdev_*() calls:
> ERROR: "led_classdev_register" [drivers/input/misc/apanel.ko] undefined!
> ERROR: "__led_classdev_unregister" [drivers/input/misc/apanel.ko] undefined!

I have assumed that Dmitry will be handling this one.
