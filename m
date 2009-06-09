Return-Path: <linux-kernel-owner+w=401wt.eu-S1759021AbZFIKu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021AbZFIKu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759019AbZFIKuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:50:13 -0400
Received: from ns.penguin.cz ([84.21.108.25]:39809 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758666AbZFIKuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:50:12 -0400
Subject: Re: zaurus needs generic pxa suspend/resume routines
From: Stanislav Brabec <utx@penguin.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com
In-Reply-To: <f17812d70906081843x6731898fl35252664e5a580a1@mail.gmail.com>
References: <20090605131625.GC1376@ucw.cz>
	 <20090607152152.GA7785@n2100.arm.linux.org.uk>
	 <f17812d70906072358i69b4ce09oeb6cd455277b050f@mail.gmail.com>
	 <20090608161929.GD32140@n2100.arm.linux.org.uk>
	 <f17812d70906081843x6731898fl35252664e5a580a1@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Tue, 09 Jun 2009 12:50:00 +0200
Message-Id: <1244544600.9997.8.camel@hammer.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Miao wrote:

> >> Yes, I think this is the best trade-off for the moment.
> >>
> >> Acked-by: Eric Miao <eric.miao@marvell.com>
> >>

However resume still does not work with this patch on top of yesterday's
Linus tree snapshot (SL-C3200, ccc0d38). It seems to go to resume for
~300 milliseconds (orange LED lights for a moment, power consumption
increases) and then runs back to the sleep. It seems that it disables
offline charging, too. When battery cover switch is open it goes to
resume just for ~50 milliseconds (orange LED does not light).

The last Pavel's hack from last week at least fixed resume at cost of
breaking offline charging (and broken serial after resume).

-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                          e-mail: sbrabec@suse.cz
Lihovarská 1060/12           tel: +420 284 028 966, +49 911 740538747
190 00 Praha 9                                  fax: +420 284 028 951
Czech Republic                                    http://www.suse.cz/

