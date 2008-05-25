Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbYEYSyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbYEYSyQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756793AbYEYSyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:54:01 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:36073 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbYEYSyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:54:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 20:53:36 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>
References: <1211550282.28967.8.camel@pmac.infradead.org> <200805252039.17673.mb@bu3sch.de> <BF546351-0C53-41C4-977A-6A777AF4D602@holtmann.org>
In-Reply-To: <BF546351-0C53-41C4-977A-6A777AF4D602@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805252053.36854.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 May 2008 20:46:00 Marcel Holtmann wrote:
> we can change these things. We do it all the time.

Doing something stupid all the time is not that of a good idea.

> Again, I don't plan to break any setup. I actually do think it is a  
> good idea to group firmware files in subdirectories in /lib/firmware,  
> but this subdirectory name doesn't belong in the kernel.
> 
> We will update udev to read the driver name and look into /lib/ 
> firmware/<driver>/<filename> and /lib/firmware/<filename> for the  
> firmware file.
> 
> Then we will set a date and note it in the future remove document.  
> Something like 12 month after an updated udev has been released. This  
> gives the distribution two generations time to update udev and kernel  
> packages.

How are you going to handle multiple versions of the firmware for one driver?
How does one switch between versions (changing config files is not acceptable)?

-- 
Greetings Michael.
