Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbYEYTWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbYEYTWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbYEYTWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:22:22 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:39405 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236AbYEYTWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:22:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 21:21:53 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>
References: <1211550282.28967.8.camel@pmac.infradead.org> <200805252053.36854.mb@bu3sch.de> <A0703DD1-0E98-4B7E-81C0-67332B6873BA@holtmann.org>
In-Reply-To: <A0703DD1-0E98-4B7E-81C0-67332B6873BA@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805252121.54375.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 May 2008 21:03:56 Marcel Holtmann wrote:
> > How are you going to handle multiple versions of the firmware for  
> > one driver?
> > How does one switch between versions (changing config files is not  
> > acceptable)?
> 
> that is your point of view. Why is changing a config file not  
> acceptable?

Because I need to change between different versions of firmware
every few minutes while developing on firmware level.
Besides that the driver must be allowed to tell whether it wants to
have one or the other version of the firmware (see my previous mail).
So this must not be a userspace-only policy.

-- 
Greetings Michael.
