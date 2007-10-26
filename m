Return-Path: <linux-kernel-owner+w=401wt.eu-S1760663AbXJZNsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760663AbXJZNsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 09:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbXJZNsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 09:48:22 -0400
Received: from static-72-92-88-10.phlapa.fios.verizon.net ([72.92.88.10]:36055
	"EHLO smtp.roinet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbXJZNsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 09:48:21 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 09:48:21 EDT
Message-ID: <4721EEA8.1060601@roinet.com>
Date: Fri, 26 Oct 2007 09:42:00 -0400
From: David Acker <dacker@roinet.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Jeff Garzik <jgarzik@pobox.com>, Bill Davidsen <davidsen@tmr.com>,
       Adrian Bunk <bunk@kernel.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, saw@saw.sw.com.sg
Subject: Re: [2.6.25 patch] the planned eepro100 removal
References: <20071024162440.GN30533@stusta.de> <4720FFAA.9080709@tmr.com> <47211A67.2090201@pobox.com> <47211C08.2040601@intel.com>
In-Reply-To: <47211C08.2040601@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
> Jeff Garzik wrote:
>> Bill Davidsen wrote:
>>> Adrian Bunk wrote:
>>>> This patch contains the planned removal of the eepro100 driver.
>>>>
>>> Are the e100 people satisfied that e100 now handles all known cases? I 
>> Nope.  There are still e100 work outstanding that means we cannot kill
>> eepro100.
> 
> Agreed, there is still a receive unit hang in the last version that I got from
> David Acker.
> 
> Auke
Yes, I have not had much time to work on it.  :-(

In testing, I was also able to get crashes which I believe are from receive skb corruption.

It doesn't ever appear in our normal use testing, just when using pktgen against it while it uses pktgen out.  Sadly 
this has pushed it down the slippery priority slope.

I am sorry if I am holding things up.  I will try to put some more time in on this issue as soon as I can.

-Ack
