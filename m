Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbYGFPxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbYGFPxA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 11:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbYGFPww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 11:52:52 -0400
Received: from zakalwe.fi ([80.83.5.154]:39321 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbYGFPww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 11:52:52 -0400
Date: Sun, 6 Jul 2008 18:52:45 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26-rc9 load problem
Message-ID: <20080706155245.GB4379@zakalwe.fi>
References: <20080706142516.GA4379@zakalwe.fi> <20080706073726.72074a3c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080706073726.72074a3c@infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 07:37:26AM -0700, Arjan van de Ven wrote:
> On Sun, 6 Jul 2008 17:25:16 +0300
> Heikki Orsila <shdl@zakalwe.fi> wrote:
> 
> > Testing 2.6.26-rc9. Doing:
> > 
> > 	dd if=/dev/hda of=/dev/null bs=4096
> > 
> > causes the operating system to feel very unresponsible.
> > Even the key repeat interval at tty1 is unpredictable.
> 
> Hi,
> 
> do you have an idea which version you tried last which didn't show this
> behavior?

Actually, this was the first vanilla kernel I tried on _this_ 
workstation. The earlier kernel came from Debian (testing).

It turns out I screwed up the kernel config which caused this. VIA PATA 
driver was not used, but a generic IDE chipset driver :/ Probably it 
didn't use DMA so the system became very sluggish.

The system is fine now. Thanks for your help, anyway.

-- 
Heikki Orsila
heikki.orsila@iki.fi
http://www.iki.fi/shd
