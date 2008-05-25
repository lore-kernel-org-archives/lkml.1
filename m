Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbYEYS2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbYEYS2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYEYS2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:28:16 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:32922 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbYEYS2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:28:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 20:27:50 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>
References: <1211550282.28967.8.camel@pmac.infradead.org> <200805251545.25516.mb@bu3sch.de> <7BD202F0-0E0E-495D-93CA-45F2E5AA8065@holtmann.org>
In-Reply-To: <7BD202F0-0E0E-495D-93CA-45F2E5AA8065@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805252027.51377.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 May 2008 20:15:13 Marcel Holtmann wrote:
> don't give me that crap. Nobody plans to break everything just right  
> now and leave people hanging in between. We will do a smooth  
> transition. Your users won't even notice it.

Right. I will forward any complain mail to you then.
This is not the first time we (need to) change the firmware ABI, so I
pretty much know what I'm talking about.

I still didn't see a single valid reason in the whole thread that explains
why we suddenly have to forbid the use of the "/" character. (and that's
really what my problem only is about)

> And we change the API/ABI all the time. Get used to it.

Right. And endusers are really scared by it.
Other operating systems out there can live without ABI breakage for 10 years.

Breakage example? I have a server running Ubuntu Dapper. I'm running a 2.6.23 kernel on
it and it complains that several features used by the dapper udev will go away in
a future kernel release. So if I want to update the kernel (security update or
for whatever reason) I need to upgrade the whole distribution, basically.
That is OK and I will do this. But this just shows that we really must try hard
to avoid breaking the udev ABI.
And I don't see this happening here.

-- 
Greetings Michael.
