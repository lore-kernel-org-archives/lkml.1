Return-Path: <linux-kernel-owner+w=401wt.eu-S1031024AbXDPW02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031024AbXDPW02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 18:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031021AbXDPW02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 18:26:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031019AbXDPW00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 18:26:26 -0400
Message-ID: <4623F804.3020405@redhat.com>
Date: Mon, 16 Apr 2007 18:26:12 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Pavel Machek <pavel@ucw.cz>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <461D4E2C.6000704@redhat.com> <20070414105255.GB9157@ucw.cz> <20070415155343.GA12069@khazad-dum.debian.net> <Pine.LNX.4.61.0704152050150.27018@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704152050150.27018@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Apr 15 2007 12:53, Henrique de Moraes Holschuh wrote:
>> On Sat, 14 Apr 2007, Pavel Machek wrote:
>>> How common are notebooks that cut power to disks during reboot?
>> Assuming it also does this when running Windows, I'd report it as a grave
>> bug to the vendor and demand it to be fixed, or the machine to be exchanged
>> with another model that doesn't have this defect.
> 
> Given that it does not happen on Windows (IIRC Chuck's post),
> then just what is Windows [not] doing that Linux does?

It looks like there are two problems here:

(1) Some notebooks power off and back on when restarting.
    Both Linux and other OS handle that badly because they
    assume power is not interrupted on reboot. The noise
    emitted is relatively loud.

(2) Linux (alone) gives a very muted pop on shutdown. This could
    be from bad interaction with the shutdown command, or some
    other reason (drive not given enough time to shut down?)
    The noise is not very loud, maybe the head did not have to
    move very far?

