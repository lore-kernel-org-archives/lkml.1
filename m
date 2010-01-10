Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054Ab0AJBfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab0AJBfb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 20:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500Ab0AJBfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 20:35:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:59775 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0AJBfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 20:35:30 -0500
Date: Sat, 9 Jan 2010 17:38:06 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: Alex Chiang <achiang@hp.com>, Len Brown <lenb@kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: High cpu temperature with 2.6.32, bisection shows commit 69d258
 (fwd)
Message-ID: <20100109173806.31fed620@infradead.org>
In-Reply-To: <alpine.LNX.2.00.1001100251210.1334@localhost.localdomain>
References: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain>
	<20100108171513.GB22713@ldl.fc.hp.com>
	<20100109134352.3dedd4ea@infradead.org>
	<alpine.LNX.2.00.1001100155370.1325@localhost.localdomain>
	<20100109160836.26a344a9@infradead.org>
	<alpine.LNX.2.00.1001100226570.1325@localhost.localdomain>
	<20100109164240.43b21247@infradead.org>
	<alpine.LNX.2.00.1001100251210.1334@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010 03:05:38 +0200 (EET)
Dimitrios Apostolou <jimis@gmx.net> wrote:

> 
> So thanks for the patch, I guess it works, and my bet is that this 
> case applies to L8400* (not only B models), except if it is fixed by
> some old BIOS upgrade that I must have missed.
> 
> While testing your patch, indeed the temperature was not rising and 
> everything was normal, but the tsc was not marked as unstable so it
> didn't switch to acpi_pm clocksource, so that was probably the reason.

that's a feature ;-)

tsc is much nicer than acpi_pm. 

now, if you have working C2 you get power savings back for going the
going-back-to-acpi_pm... but since for you, C2 doesn't.... you're now
much better off ...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
