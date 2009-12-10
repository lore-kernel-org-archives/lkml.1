Return-Path: <linux-kernel-owner+w=401wt.eu-S933941AbZLJK61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933941AbZLJK61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 05:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933861AbZLJK6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 05:58:24 -0500
Received: from mail-qy0-f202.google.com ([209.85.221.202]:55383 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933751AbZLJK6X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 05:58:23 -0500
X-Greylist: delayed 1229 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Dec 2009 05:58:23 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sfBdZloTxGApW0EjMPl9M1U1n8cyNgXVIdVkP96NpjfHIbxGZE9pG/nWXbSa4hgBqb
         WLhWaWlkXqk+V6214voHWHersn8lp/ua6CRgxa/qjRCeNT8HLizzfTLMoLbcth6pCD/8
         0EdmHe/+y5+A2HyKbgnayrfZpGwHu19RxBg4A=
MIME-Version: 1.0
In-Reply-To: <20091210101423.GF2446@ucw.cz>
References: <1260257169-7227-1-git-send-email-ike.pan@canonical.com>
	 <20091210100935.GB2446@ucw.cz>
	 <71cd59b00912100238l7fe78abcrd07328c15b65971d@mail.gmail.com>
	 <20091210101423.GF2446@ucw.cz>
Date: Thu, 10 Dec 2009 11:58:29 +0100
Message-ID: <71cd59b00912100258l1230f5e6p3e81e9c716f32987@mail.gmail.com>
Subject: Re: [PATCH] asus-laptop: add Lenovo SL LenovoCare LED support
From: Corentin Chary <corentin.chary@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ike Panhc <ike.pan@canonical.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Alexandre Rostovtsev <tetromino@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 11:14 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Thu 2009-12-10 11:38:00, Corentin Chary wrote:
>> On Thu, Dec 10, 2009 at 11:09 AM, Pavel Machek <pavel@ucw.cz> wrote:
>> > On Tue 2009-12-08 15:26:09, Ike Panhc wrote:
>> >> From: Ike Panhc <ikepanhc@canonical.com>
>> >>
>> >> This patch is to enable the LenovoCare LED support on Lenovo SL laptop. Based
>> >> on the found of the control interface by Alexandre Rostovtsev
>> >>
>> >> Turn on the LenovoCare LED:
>> >>  (As root privileges) echo 1 > /sys/class/leds/asus\:\:LenovoCare/brightness
>> >> Trun off the LenovoCare LED:
>> >>  (As root privileges) echo 0 > /sys/class/leds/asus\:\:LenovoCare/brightness
>> >>
>> >> The patch against current checkout of acpi4asus is below.
>> >
>> > Is the driver severely misnamed by now? I believe Lenovo and ASUS are
>> > pretty different firms...
>> >
>>
>> Lenovo ship DSDT with similar ATKD interace.
>> See http://git.iksaif.net/?p=acpi4asus.git;a=commitdiff;h=31a38147625c283b58137db45e7507cd1e49aa05
>>
>
> So what? Rename the driver... having Asus::lenovocare led is just wrong.

asus::lenovocare led won't be in asus-laptop (see the whole discussion).

All specific lenovo things will be in a new lenevo specific driver.
asus-laptop also support some MEDION, JVC or VICTOR laptops, but these
are only exceptions.

-- 
Corentin Chary
http://xf.iksaif.net
