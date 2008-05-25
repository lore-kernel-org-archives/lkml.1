Return-Path: <linux-kernel-owner+w=401wt.eu-S1762416AbYEYMOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762416AbYEYMOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 08:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759382AbYEYMO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 08:14:28 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:46967 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759083AbYEYMO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 08:14:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 14:14:03 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>
References: <1211550282.28967.8.camel@pmac.infradead.org> <200805251149.41059.mb@bu3sch.de> <9995307A-E602-4A30-8900-6AEDDF7D1D8F@holtmann.org>
In-Reply-To: <9995307A-E602-4A30-8900-6AEDDF7D1D8F@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805251414.04509.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 May 2008 13:54:32 Marcel Holtmann wrote:
> I am okay with userspace supporting namespacing with subdirectories  
> and see the point why it helps, but the important here is that  
> userspace must support this. It should not be done inside the kernel.

The decision is currently not made in the kernel. It's a udev
decision to use / as directory separator. We exploit that udev
feature to use a convenient dir structure. But that is unrelated
to how any new database will handle it. The in-kernel database should
treat / like any other char.

> So we have to change udev to look for /lib/firmware/<driver>/ 
> <filename> which perfectly fine, but the <driver> part needs to be  
> derived from struct device and not from the <filename> part.

What if I want 2 or 3 different firmware versions installed at once?
I'll have to play dirty tricks with the filenames then and put several
unrelated firmware versions into one directory. That's going to be a mess.

-- 
Greetings Michael.
