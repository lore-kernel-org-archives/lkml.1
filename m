Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbYISVVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbYISVVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 17:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYISVVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 17:21:02 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:18904 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbYISVVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 17:21:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jsjjuP9MqBJ5QaWAbdnE2vZXmhEbv+iyYXq7ztDSRNel03BvF2wYOsZKc6hXoFs47D
         2XNQTOT4cZ0xKF9Y61x33o5tAGkWVRUJzDbyTGFGWbpDbtqlsEb+t3iUmWt9fFk7v9A/
         DZsEmNRHiQE7aK3wNnnjMddsKWtY5jvH9jysU=
Message-ID: <dd18b0c30809191420xe1ff525rbf59bb5d9f9910b2@mail.gmail.com>
Date: Fri, 19 Sep 2008 17:20:59 -0400
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [19.666764] Disabling IRQ #23
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Chris Snook" <csnook@redhat.com>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       Linux-usb <linux-usb@vger.kernel.org>
In-Reply-To: <dd18b0c30809191118u20a13ff3m801a23397eb6beed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30809190941g8b44175haf3e3a7c354fe01c@mail.gmail.com>
	 <Pine.LNX.4.44L0.0809191304050.2142-100000@iolanthe.rowland.org>
	 <dd18b0c30809191118u20a13ff3m801a23397eb6beed@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 2:18 PM, Justin Mattock <justinmattock@gmail.com> wrote:
> On Fri, Sep 19, 2008 at 10:05 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> On Fri, 19 Sep 2008, Justin Mattock wrote:
>>
>>> The disable irq #23 message.
>>>
>>> As for the HC died; cleaning up
>>> (where did you see that, can't seem to find that?)
>>
>> It's in your original message:
>>
>>        http://marc.info/?l=linux-kernel&m=122107367715361&w=2
>>
>> The line with timestamp 16.068174.
>>
>> Alan Stern
>>
>>
>
> ahh there it is...
> I've been so focused on making sure
> uvcvideo is loading everything properly, I forgot to
> see what happens when I load everything without
> any of the uvcvideo stuff.
>
>
> --
> Justin P. Mattock
>

Hmm, I know you said none of the userspace
apps should cause this.
I not sure but, I might
be having a clash between udev and hal
(not a clean install of isight-firmware-tools);
when installing these items using the udev approach
I noticed some files still remaining(below is the path)
/usr/local/share/hal/fdi/preprobe/20thirdparty/50-isight-firmware.fdi
when removing this file the system runs without any issues with the
udev approach,
as soon as I add this file:
disable irq #23 appears.(but not all the time).


-- 
Justin P. Mattock
