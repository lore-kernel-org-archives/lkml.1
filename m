Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039Ab0CMLOM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 06:14:12 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51826 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759016Ab0CMLOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 06:14:09 -0500
Date: Sat, 13 Mar 2010 12:14:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       ACPI mailing list <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.34-rc1: lockdep warning on geode subnotebook
Message-ID: <20100313111402.GA2192@elf.ucw.cz>
References: <20100313105109.GA9966@elf.ucw.cz>
 <201003131159.47768.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201003131159.47768.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-03-13 11:59:47, Oliver Neukum wrote:
> Am Samstag, 13. März 2010 11:51:09 schrieb Pavel Machek:
> > sysfs related? ACPI?
> > 
> > Switching to clocksource acpi_pm
> > Switched to NOHz mode on CPU #0
> > BUG: key df3f6edc not in .data!
> > ------------[ cut here ]------------
> > WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x448/0x500()
> > Hardware name: SA Series
> 
> I get the same warning. It is not specific to that hardware.

Yep, happens on thinkpad x60, too.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
