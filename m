Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbXFBEhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbXFBEhS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 00:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbXFBEhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 00:37:07 -0400
Received: from chen.mtu.ru ([195.34.34.232]:3236 "EHLO chen.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbXFBEhG (ORCPT <rfc822; linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 00:37:06 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
To: Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de>,
       linux-kernel@vger.kernel.org
Date: Sat, 02 Jun 2007 08:36:03 +0400
References: <878xb35sje.fsf@goat.bogus.local>
User-Agent: KNode/0.10.5
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20070602043604.5887E558E6B@chen.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Dietsche wrote:

> resume from suspend to ram doesn't work for my laptop and never
> has. So, this is not a regression.
> 
> Hibernate (aka suspend to disk) works, however.
> 
> When I resume, everything seems to come up (fan becomes busy, disk and
> dvd spin up for a short time), but the machine is not responding to
> anything - neither keyboard, mouse nor ping from another machine. The
> laptop is effectively dead and only a power cycle helps.
> 

I understand that every case of failed resume is different, but this looks
quite similar to the problem I have:
http://bugzilla.kernel.org/show_bug.cgi?id=7499, at least symptoms :)

> I've tried a minimal config and init=/bin/bash as well, but the result
> is the same.
> 

One more similarity :) And BTW s2ram does not work either.

-andrey

