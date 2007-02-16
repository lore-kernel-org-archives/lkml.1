Return-Path: <linux-kernel-owner+w=401wt.eu-S1946252AbXBPVT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946252AbXBPVT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 16:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946258AbXBPVT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 16:19:27 -0500
Received: from mail.trixing.net ([87.230.125.58]:38091 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946252AbXBPVT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 16:19:27 -0500
Message-ID: <45D61FC8.4020604@l4x.org>
Date: Fri, 16 Feb 2007 22:19:04 +0100
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061220 Thunderbird/1.5.0.9 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@enneenne.com>
CC: linux-kernel@vger.kernel.org
References: <20070216185230.GO8882@enneenne.com> <45D60C62.5080806@l4x.org> <20070216205747.GC4641@enneenne.com>
In-Reply-To: <20070216205747.GC4641@enneenne.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.37
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
X-SA-Exim-Version: 4.2.1 (built Mon, 27 Mar 2006 14:12:04 +0200)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rodolfo Giometti wrote:
>>> +PROCFS support
>>> +--------------
>> New features shouldn't introduce new /proc stuff.
> 
> It's a must? I can leave procfs for backward compatibility with old
> utilities?

Hmm, as this is a new feature with regard to the mainline kernel, old
utilities don't count (if you can install a new kernel you can also
be expected to install new user-space tools for the new feature).

>> You read the comment above your line?
> 
> No, sorry. I'm going to choose another id number... or can I keep 17?

I don't know, ask whoever is responsible for the file.

>>> +#define to_class_dev(obj) container_of((obj), struct class_device, kobj)
>> pretty generic name.
> 
> I should change it?

If it's of general use put it in the appropriate header file. If it's
just for the pps subsystem name it as such.

>> Have you thought about 32/64bit issues?
> 
> No. I have no 64 bits machine to test the code...

Hmm, think about x86_64 with 64-bit kernel and 32-bit userspace, probably
having got different padding in the struct. Read LDD3, chapter 11,
especially 11.4 .

Jan
