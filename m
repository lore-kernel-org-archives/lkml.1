Return-Path: <linux-kernel-owner+w=401wt.eu-S933458AbXDAPkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbXDAPkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 11:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933473AbXDAPkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 11:40:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2841 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933458AbXDAPkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 11:40:02 -0400
Date: Sun, 1 Apr 2007 15:39:52 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-ID: <20070401153951.GE5095@ucw.cz>
References: <45D5EA88.7090300@redhat.com> <45D6DDCE.5050803@assembler.cz> <45D7461A.2040808@redhat.com> <20070218183805.5a4fd813.khali@linux-fr.org> <20070228213803.GA4877@ucw.cz> <20070301152655.f232db64.khali@linux-fr.org> <20070302114023.GD2163@elf.ucw.cz> <20070302114747.GB1212@srcf.ucam.org> <20070302135810.GF2156@elf.ucw.cz> <20070302220052.f93f3976.khali@linux-fr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302220052.f93f3976.khali@linux-fr.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Actually for the acpi stuff... we might wrap ACPI interpretter with a
> > semaphore that needs to be taken before starting any AML code. Then
> > just make sure sensors take same semaphore?
> 
> I like the idea, it should work as long as we are guaranteed that all
> the hwmon device accesses happen in the AML code? I'm not familiar with
> ACPI, so you tell me.
> 
> In practice it's rather the SMBus drivers which will need to take the
> lock, as this is what the AML code will access (for SMBus-based
> hardware monitoring drivers.) For non-SMBus based hardware monitoring
> drivers, indeed the driver itself should take it. We will have to pay
> attention to deadlocks on systems with multiple hardware monitoring
> chips and/or SMBus channels.
> 
> Can you please provide a patch implementing your proposal in acpi? Then
> I could implement the i2c/hwmon part on some selected drivers and start
> testing real world scenarii.

I'm sorry, but I do not have time for a patch.... and I'm not really
acpi expert, anyway. Ask Len?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
