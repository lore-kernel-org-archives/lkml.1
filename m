Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab0BRADJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:03:09 -0500
Received: from eazy.amigager.de ([213.239.192.238]:56219 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024Ab0BRADH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:03:07 -0500
Date: Thu, 18 Feb 2010 01:02:59 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.33-rc8 regression on i915: resume from hibernate locks up
 every 2nd time
Message-ID: <20100218000259.GA16380@x61.home>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <74fd948d1002171047g70d2bba0l957e264dfbc8ea23@mail.gmail.com>
 <201002172152.39255.rjw@sisk.pl>
 <74fd948d1002171410l5688c3dfy125ac5c7e80ad1a1@mail.gmail.com>
 <201002172320.57491.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002172320.57491.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 23:20:57 +0100, Rafael J. Wysocki wrote:

[...]

> First, please try if you can reproduce it with non-modular driver.

I got hangs at resume on my ThinkPad X61s with i965 graphics and
non-modular i915 driver. I got the hangs after suspend to RAM and
suspend to disk using TuxOnIce, but not every time. I reverted the 
commit metioned by Pedro and wasn't able to reproduce the hang after
several suspend cycles.

I'll also try the attached patch.

Regards,
Tino
