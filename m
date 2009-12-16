Return-Path: <linux-kernel-owner+w=401wt.eu-S1762095AbZLPLWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762095AbZLPLWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 06:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762068AbZLPLWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 06:22:47 -0500
Received: from 007.netroom.de ([194.0.247.207]:2228 "EHLO 007.netroom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762065AbZLPLWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 06:22:46 -0500
Message-ID: <4B28C2F7.7040207@draisberghof.de>
Date: Wed, 16 Dec 2009 12:22:31 +0100
From: Josua Dietze <digidietze@draisberghof.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
CC: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com>	<4B278191.1010009@draisberghof.de>	<200912151611.08576.oliver@neukum.org>	<20091215180300.GF16426@one-eyed-alien.net> <20091216114932.4bede511@strolchi.home.s3e.de>
In-Reply-To: <20091216114932.4bede511@strolchi.home.s3e.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Seyfried schrieb:

> On Tue, 15 Dec 2009 10:03:00 -0800
> Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:
>> The right answer here is neither to move the eject code nor to introduce
>> more of it.  New devices should be supported via userspace.
> 
> Can somebody point me to the "userspace" that is meant here?
> Preferably some code that can be built actually?


If the "eject" from SCSI tools does not work, "usb_modeswitch" can 
send customized bulk messages to devices.

http://www.draisberghof.de/usb_modeswitch/


Josh
-- 
Man is the only creature on earth enabled to take a
warm meal while flying!                      Loriot
