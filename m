Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbXCOKZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbXCOKZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 06:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbXCOKZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 06:25:20 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:39172 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbXCOKZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 06:25:19 -0400
To: Andreas Jellinghaus <aj@leogic.com>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: rsdl 30 on 2.6.20.2 breaks user space usb
References: <200703151054.29591.aj@leogic.com>
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Date: Thu, 15 Mar 2007 13:25:16 +0300
In-Reply-To: <200703151054.29591.aj@leogic.com> (Andreas Jellinghaus's message of "Thu\, 15 Mar 2007 10\:54\:29 +0100")
Message-ID: <87mz2e7qib.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Jellinghaus <aj@leogic.com> writes:

> with plain 2.6.20.2 I get events / called from udev for /proc/bus/usb devices.
> with rsdl 0.30 added to the kernel I no longer get called for those devices
> (but I do get called for the new /dev/usbdev devices - except that I can't use 
> them).
>
> any idea why and what to do? might be related to a race condition.

sounds like http://bugzilla.kernel.org/show_bug.cgi?id=8166#c32
