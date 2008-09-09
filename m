Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbYIIQnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbYIIQnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYIIQnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:43:00 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60212 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbYIIQnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:43:00 -0400
Date: Tue, 9 Sep 2008 17:42:54 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Re: Controlling backlight on thinkpad x60
Message-ID: <20080909164254.GA25463@srcf.ucam.org>
References: <20080908151058.GA1650@elf.ucw.cz> <20080908155457.GA30619@srcf.ucam.org> <20080909152859.GA1813@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909152859.GA1813@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 05:29:00PM +0200, Pavel Machek wrote:
> That's bad then, because ACPI video support does not work here. I can
> boot, and even Fn-home/end works, but it breaks with X.
> 
> In old versions, it resulted on black screen after LID close in X.

Yeah, X did retarded things in response to video events. That's been 
fixed for ages.

> In 2.6.27-rc5, screen goes black as soon as X are started.

That sounds bizarre, and I can't reproduce it here.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
