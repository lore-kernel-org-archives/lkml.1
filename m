Return-Path: <linux-kernel-owner+w=401wt.eu-S964960AbXDMUIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964960AbXDMUIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964873AbXDMUIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:08:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39859 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964976AbXDMUIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:08:38 -0400
Date: Fri, 13 Apr 2007 22:07:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jean Delvare <khali@linux-fr.org>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-ID: <20070413200746.GD28264@elf.ucw.cz>
References: <45D5EA88.7090300@redhat.com> <20070302114023.GD2163@elf.ucw.cz> <20070302150313.198b6053.khali@linux-fr.org> <200704131218.44045.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704131218.44045.bjorn.helgaas@hp.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ... The primary issue is the concurrent access
> > to resources, which cause lots of trouble which are hard to investigate.
> > If ACPI reserves the ports, then the SMBus or hardware monitoring
> > drivers (or any other conflicting driver) will cleanly fail to load,
> > which would be a move in the right direction. ...
> > 
> > So, can ACPI actually reserve the ports it accesses?
> 
> Sorry to join this discussion so late.
> 
> ACPI tells us the resources used by devices.  Today, we don't
> reserve

Problem seems to be that ACPI does _not_ tell us which ports it
accesses from AML code.

But we already found a lock we can take; AFAICT we know how to solve
this problem.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
