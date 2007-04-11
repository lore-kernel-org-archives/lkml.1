Return-Path: <linux-kernel-owner+w=401wt.eu-S1161219AbXDKVgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161219AbXDKVgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 17:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030241AbXDKVgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 17:36:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965292AbXDKVgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 17:36:04 -0400
Message-ID: <461D54AF.3060706@redhat.com>
Date: Wed, 11 Apr 2007 17:35:43 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <461D4E2C.6000704@redhat.com> <Pine.LNX.4.61.0704112315480.20436@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704112315480.20436@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Apr 11 2007 17:07, Chuck Ebbert wrote:
>> When I reboot my notebook, it powers off and powers back on.
>> On poweroff a loud snapping noise seems to be coming from the
>> hard drive. Today I noticed there is no "shutdown: hda" on
>> the console when I reboot. Whne I do a normal poweroff the
>> message is displayed and there is no noise. Should the IDE
>> code be changed so it always shuts down the drive?
> 
> What sort of notebook? What sort of harddisk?

Compaq Presario V2000 series, with a new Seagate ST9120821A
120GB 5400RPM drive.

> Is it as loud as `hdparm -y /dev/hdX"?

That makes no noise at all except normal drive seek noises.

> Try `smartctl -d ata -a /dev/hdX | grep -i unload` too.

Hmm.

Power_Cycle_Count ... 108
Power-Off_Retract_Count ... 90

I did a normal poweroff and the retract count went to 91.
There is an almost-unnoticeable click when I do it that way.

