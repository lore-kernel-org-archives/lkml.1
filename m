Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbYEYSHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbYEYSHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbYEYSHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:07:45 -0400
Received: from senator.holtmann.net ([87.106.208.187]:44238 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbYEYSHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:07:44 -0400
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Michael Buesch <mb@bu3sch.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>
Message-Id: <D388B096-F1D8-4A96-B400-EC5C28021FAD@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1211723218.31212.104.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 20:07:38 +0200
References: <1211550282.28967.8.camel@pmac.infradead.org> <200805251149.41059.mb@bu3sch.de> <9995307A-E602-4A30-8900-6AEDDF7D1D8F@holtmann.org> <200805251414.04509.mb@bu3sch.de>  <20080525141638.65111d64@core> <1211723218.31212.104.camel@shinybook.infradead.org>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

>>> What if I want 2 or 3 different firmware versions installed at once?
>>> I'll have to play dirty tricks with the filenames then and put  
>>> several
>>> unrelated firmware versions into one directory. That's going to be  
>>> a mess.
>>
>> You add the desired feature to udev, or use symlinks. Hardly a  
>> "mess".
>
> It's a bit of a pain for the in-kernel firmware loading that I'm  
> working
> on now, if we can no longer count on the requested string to be the
> single match criterion.

the in-kernel firmware loading can use a total different policy on how  
to match the firmware filenames and driver names to a directory/ 
filename.

Regards

Marcel

