Return-Path: <linux-kernel-owner+w=401wt.eu-S1759872AbYAQWAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbYAQWAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbYAQWAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:00:13 -0500
Received: from tomts24-srv.bellnexxia.net ([209.226.175.187]:44409 "EHLO
	tomts24-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756490AbYAQWAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:00:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAPpdj0dFn+Sr/2dsb2JhbACuEQQ
Date: Thu, 17 Jan 2008 17:00:03 -0500
From: Mike Houston <mikeserv@bmts.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jean Delvare <khali@linux-fr.org>, bugme-daemon@bugzilla.kernel.org,
       "Shaohua Li" <shaohua.li@intel.com>, "Mike Houston" <mikeserv@bmts.com>,
       "Adrian Bunk" <bunk@stusta.de>, "Elvis Pranskevichus" <el@prans.net>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       "Adam Belay" <ambx1@neo.rr.com>, "Zhao Yakui" <yakui.zhao@intel.com>,
       "Thomas Renninger" <trenn@suse.de>, lenb@kernel.org,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, linux-acpi@vger.kernel.org
Subject: Re: [Bug 9514] it87 probe failure in 2.6.24-rc -- what now?
Message-Id: <20080117170003.7297ce39.mikeserv@bmts.com>
In-Reply-To: <200801171339.00887.bjorn.helgaas@hp.com>
References: <200801171339.00887.bjorn.helgaas@hp.com>
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.10.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 13:38:57 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> Where are we with this problem?
> (http://bugzilla.kernel.org/show_bug.cgi?id=9514)

> The second option I see is to use my patch
> (http://bugzilla.kernel.org/attachment.cgi?id=14267&action=view)
> to make it87 request only the ports it uses.

> Whatever we do, it'd be nice to have a fix in 2.6.24, and I think my
> patch is the least evil for now.

>From my perspective it sure seems to be the least evil, because it
only touches what needs to be touched for my situation. I of course
can't say how it would affect others.

I'm still using your patch (on 2.6.24-rc8 now) but I'll test whatever
other solutions you folks may come up with.

Mike Houston
