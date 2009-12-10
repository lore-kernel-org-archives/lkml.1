Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbZLJCtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbZLJCtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 21:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758172AbZLJCtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 21:49:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758026AbZLJCtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 21:49:09 -0500
Date: Wed, 9 Dec 2009 18:48:34 -0800
From: Greg KH <gregkh@suse.de>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       dsilvers@simtec.co.uk, ben@simtec.co.uk, Artem.Bityutskiy@nokia.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/3] gpiolib: add support for having symlinks under
	gpio class directory
Message-ID: <20091210024834.GB20410@suse.de>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <71eff9c88d3fec3daa218341c83c19a106ee1f62.1260364108.git.ext-jani.1.nikula@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71eff9c88d3fec3daa218341c83c19a106ee1f62.1260364108.git.ext-jani.1.nikula@nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 03:49:03PM +0200, Jani Nikula wrote:
> Extend the functionality of gpio_export_link() to allow exported GPIOs
> to have names using sysfs links under /sys/class/gpio.

No, please don't create symlinks under a class, that is not something
that any userspace tool is expecting.

I don't understand what you are trying to do here, why do you need a
symlink?  What is wrong with the original device names?

confused,

greg k-h
