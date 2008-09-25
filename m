Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbYIYSwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbYIYSwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbYIYSw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:52:27 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:37539 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbYIYSw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:52:26 -0400
Message-ID: <48DBDDE6.3060301@free.fr>
Date: Thu, 25 Sep 2008 20:52:22 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080702 Iceape/1.1.11 (Debian-1.1.11-1)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Martin Doucha <next_ghost@quick.cz>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 11603] Re: ACPI PnP on Intel MU440EX
References: <48BA9B2C.7060007@quick.cz> <200809221701.13569.bjorn.helgaas@hp.com> <48D95FB2.4050108@free.fr> <200809241705.13410.bjorn.helgaas@hp.com>
In-Reply-To: <200809241705.13410.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
>> If you want you could try to run the attached program on your pc in 
>> "auto/bidirectional" or "auto/EPP" mode.
>>
>> This program does what _STA methods do.
> 
> I'm just curious -- what do you hope to learn from this program?
> Do you think it will tell us more than what actually running _STA
> did?
> 
Yes I was curious of the value before the mask : some of the mask and 
comparaison look strange.

> The best solution I can think of would be to have a parameter like
> "parport.nopnp" that made parport just probe the legacy addresses,
> and document that you might need that on machines with broken ACPI
> firmware.  But I'm a little afraid to touch parport_pc.c.
Aren't parport still probing it's own port if pnp failed ?


Matthieu
