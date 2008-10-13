Return-Path: <linux-kernel-owner+w=401wt.eu-S1758535AbYJMPuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbYJMPuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 11:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbYJMPtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 11:49:55 -0400
Received: from styx.suse.cz ([82.119.242.94]:40632 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755011AbYJMPty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 11:49:54 -0400
Date: Mon, 13 Oct 2008 17:49:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Dmitry Torokhov <dtor@mail.ru>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix Numlock led on two keyboards (Dell SK8115 and
 Bright)
In-Reply-To: <20081009170544.4e770dbb@pedra.chehab.org>
Message-ID: <alpine.LNX.1.10.0810131747260.26779@jikos.suse.cz>
References: <20081009170544.4e770dbb@pedra.chehab.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2008, Mauro Carvalho Chehab wrote:

> While testing two new USB keyboards, it was noticed that the NUM LOCK 
> led were wrong after booting. The led was ON, but the device was working 
> without numlock.
> Adding those two devices to HID quirks table fixed the issue.
> The keyboards are:
> DELL SK8115 (USB ID 413c:2105); and
> Bright keyboard (USB ID 1241:1503).

Hi Mauro,

the HID subsystem went through a refactoring, and all the quirks have been 
separated into individual drivers, so that the code doens't become 
unmaintainable mess by having quirks all over the place.

The changes have been present in my git tree -next for quite some time, 
and I am planning to send a push request to Linus probably tomorrow. Do 
you think you could rebase your patch on top of my tree?

For Dell changes this should be trivial, as there is already a driver 
handling exactly this for other Dell keyboards.

Thanks,

-- 
Jiri Kosina
SUSE Labs
