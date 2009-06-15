Return-Path: <linux-kernel-owner+w=401wt.eu-S1758982AbZFOMvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982AbZFOMvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbZFOMvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:51:45 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:40087 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753513AbZFOMvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:51:44 -0400
Date: Mon, 15 Jun 2009 13:51:46 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Alek Du <alek.du@intel.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and
	gpio_alt_func features to GPIOLIB
Message-ID: <20090615125146.GC19873@fluff.org.uk>
References: <20090615171502.2a981bf5@dxy.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615171502.2a981bf5@dxy.sh.intel.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 05:15:02PM +0800, Alek Du wrote:
> >From 7a76916ccea4a376a260ea67fbc79ac4d958757f Mon Sep 17 00:00:00 2001
> From: Alek Du <alek.du@intel.com>
> Date: Fri, 8 May 2009 09:46:49 +0800
> Subject: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and gpio_alt_func features to GPIOLIB
> 
> Add some more functions to GPIOLIB, they are:
> * gpio_detect is to set GPIO interrupt triggering method (edge, level, high,
>   low, etc.)

This is the wrong way of doing it, there is as a definit set_type
method in the irq_chip structure which should be used to alter the
way the IRQ is triggered.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
