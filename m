Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbZLHPCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbZLHPCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbZLHPCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:02:31 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33298 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbZLHPCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:02:30 -0500
Date: Tue, 8 Dec 2009 16:02:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v9 5/8] Loongson: YeeLoong: add hardware monitoring
	driver
Message-ID: <20091208150229.GA1375@ucw.cz>
References: <cover.1260281599.git.wuzhangjin@gmail.com> <5e9acb4cd757075f617daa45cbd6f5fad94678ac.1260281599.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e9acb4cd757075f617daa45cbd6f5fad94678ac.1260281599.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch adds hardware monitoring driver, it provides standard
> interface(/sys/class/hwmon/) for lm-sensors/sensors-applet to monitor
> the temperatures of CPU and battery, the PWM of fan, the current,
> voltage of battery.

It is probably ok for now, but in future current/voltage of battery
should be exported as power_supply class (drivers/power)...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
