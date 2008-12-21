Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbYLUK5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbYLUK5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 05:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbYLUK5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 05:57:06 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:40484 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbYLUK5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 05:57:04 -0500
Message-ID: <494E20F7.7050106@gmail.com>
Date: Sun, 21 Dec 2008 12:56:55 +0200
From: Anssi Hannula <anssi.hannula@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Parag Warudkar <parag.lkml@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: 2.6.28-rc9: USB Mouse unhappy
References: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com>	 <20081220221253.e09b1b1f.akpm@linux-foundation.org> <f7848160812202226w1f930c86vfd17a2b0163bfc56@mail.gmail.com>
In-Reply-To: <f7848160812202226w1f930c86vfd17a2b0163bfc56@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parag Warudkar wrote:
> On Sun, Dec 21, 2008 at 1:12 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> You're sure that 2.6.28-rc8 was OK?
> 
> Nope - not sure about 28-rc8. I meant to say some previous 28-rc's
> that I tested worked fine - can't recall which ones. it is likely I
> missed testing .28-rc8.
> 
>> 2.6.28-rc9 had only a small number of changes.  Nothing I can see in
>> input or HID.  A few USB changes, but pretty specific ones -
>> unusual_devs entries and such.
>>
>> Maybe your mouse has died?  Did you retest with an older kernel?
>>
> I did - rebooting into 2.6.27 (original distro kernel) makes it work again.

This sounds to me like 'usbmouse' gets used instead of 'usbhid' on
2.6.28-rc9. Many users have reported only vertical movement with
'usbmouse'. Better check the kernel configuration, if you had usbmouse
disabled in 2.6.27, then disable it with 2.6.28-rc9 as well.

-- 
Anssi Hannula
