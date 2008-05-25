Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbYEYSe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbYEYSe5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbYEYSet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:34:49 -0400
Received: from senator.holtmann.net ([87.106.208.187]:39390 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbYEYSet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:34:49 -0400
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>
Message-Id: <6BA85885-37F3-4D18-8B28-72687F5279FD@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200805252027.51377.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 20:34:43 +0200
References: <1211550282.28967.8.camel@pmac.infradead.org> <200805251545.25516.mb@bu3sch.de> <7BD202F0-0E0E-495D-93CA-45F2E5AA8065@holtmann.org> <200805252027.51377.mb@bu3sch.de>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

>> don't give me that crap. Nobody plans to break everything just right
>> now and leave people hanging in between. We will do a smooth
>> transition. Your users won't even notice it.
>
> Right. I will forward any complain mail to you then.
> This is not the first time we (need to) change the firmware ABI, so I
> pretty much know what I'm talking about.
>
> I still didn't see a single valid reason in the whole thread that  
> explains
> why we suddenly have to forbid the use of the "/" character. (and  
> that's
> really what my problem only is about)

the reason is pretty simple; the a kernel driver should not do any  
kind of policy, namespace or whatever you wanna call it. This should  
be done in userspace.

>> And we change the API/ABI all the time. Get used to it.
>
> Right. And endusers are really scared by it.
> Other operating systems out there can live without ABI breakage for  
> 10 years.

And some operating system really suffer from this ABI guarantee. I am  
not getting into this since it has been discussed so many times and  
the kernel source contains full documentation why we are not doing it.

> Breakage example? I have a server running Ubuntu Dapper. I'm running  
> a 2.6.23 kernel on
> it and it complains that several features used by the dapper udev  
> will go away in
> a future kernel release. So if I want to update the kernel (security  
> update or
> for whatever reason) I need to upgrade the whole distribution,  
> basically.
> That is OK and I will do this. But this just shows that we really  
> must try hard
> to avoid breaking the udev ABI.
> And I don't see this happening here.

We actually do and we the future remove document and the requirements  
document within the kernel source this is fully documented all of the  
time.

However you have to understand that at some point we have to make sure  
that kernel and userspace are recent. But again, this will be all  
documented and if a distro than decides to bluntly ignore it, then go  
ahead an blame the distro. The kernel depends on the "plumbing" and  
vise versa.

Regards

Marcel

