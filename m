Return-Path: <linux-kernel-owner+w=401wt.eu-S1030595AbXAYVjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030595AbXAYVjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 16:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030602AbXAYVjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 16:39:04 -0500
Received: from waste.org ([66.93.16.53]:39402 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030599AbXAYVjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 16:39:02 -0500
Date: Thu, 25 Jan 2007 15:26:22 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] suspend debugging: simulate suspend-to-RAM
Message-ID: <20070125212622.GB16722@waste.org>
References: <20070125113350.GA31068@elte.hu> <20070125180324.36E8B557CF8@chen.mtu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070125180324.36E8B557CF8@chen.mtu.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 09:03:22PM +0300, Andrey Borzenkov wrote:
> Ingo Molnar wrote:
> > Make debugging such bugs easier by offering a resume mode that does not
> > actually call into the BIOS to turn off the machine. This, in
> > combination with earlyprintk=serial,ttyS0,115200,keep ,
> > CONFIG_PM_DEBUG=y, CONFIG_DISABLE_CONSOLE_SUSPEND=y and
> > /sys/power/filter enables me to have a fully functional serial console
> > during the full suspend/resume cycle.
> >
> 
> Will it work with netconsole too? COM port is often missing in notebooks
> today.

Should, if you add your network device to the aforementioned filter.

-- 
Mathematics is the supreme nostalgia of our time.
