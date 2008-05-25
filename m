Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbYEYSPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbYEYSPe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbYEYSPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:15:21 -0400
Received: from senator.holtmann.net ([87.106.208.187]:39271 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776AbYEYSPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:15:19 -0400
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>
Message-Id: <7BD202F0-0E0E-495D-93CA-45F2E5AA8065@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200805251545.25516.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 20:15:13 +0200
References: <1211550282.28967.8.camel@pmac.infradead.org> <200805251405.05684.mb@bu3sch.de> <09817CD9-2158-4EC3-8AB4-17BBAF34A8DA@holtmann.org> <200805251545.25516.mb@bu3sch.de>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

>> this should all be done in userspace and not inside the kernel.  
>> Export
>> the special device versions via struct device and stop being lazy.
>
> No. Wait. It's not exactly going to work this way.
> You're not going to break my ABI and then tell me I'm going to work  
> around
> that, right? Answer: No.
>
> b43 will use the slash in request_firmware. That is not going to  
> change.
>
> This is _exactly_ what users are so tired about. Every now and then  
> people
> decide to change some ABI.

don't give me that crap. Nobody plans to break everything just right  
now and leave people hanging in between. We will do a smooth  
transition. Your users won't even notice it.

And we change the API/ABI all the time. Get used to it.

Regards

Marcel

