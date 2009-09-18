Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbZIRHA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbZIRHA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 03:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZIRHA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 03:00:26 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:49630 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZIRHAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 03:00:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hPTtIeTXwhB+Cq4V8K5mSs5Js+1Ht/I1pRvFi+9dzINONkEXoxMeGPi2S/BRXC8f7J
         yxLZrXt1vCVGKPxvkcW79kzUAF1/4xMqhyMrEPTg1magN1ijrm8gcoVDJYm/9aCLgy8J
         oM1XREK1kyu4jGzjwWEqNP5CaXzkh9HeHBWmU=
MIME-Version: 1.0
In-Reply-To: <646765f40909172337g74b419fegd2935cb28aedb220@mail.gmail.com>
References: <20090915174233.7db381cd@varda>
	 <200909151813.32223.IvDoorn@gmail.com>
	 <646765f40909172337g74b419fegd2935cb28aedb220@mail.gmail.com>
Date: Fri, 18 Sep 2009 09:00:28 +0200
Message-ID: <a32f33a40909180000m72d3f8cep3b97205e5ef1e26d@mail.gmail.com>
Subject: Re: [rt2x00] rt2500pci is spamming syslogd since upgrade to 2.6.31
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: =?ISO-8859-1?Q?Alejandro_Riveira_Fern=E1ndez?= <ariveira@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 8:37 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
> 2009/9/16 Ivo van Doorn <ivdoorn@gmail.com>:
>> Hi,
>>
>>>  Hi; my syslog has many entries like this since the upgrade to 2.6.31
>>>
>>>  phy0 -> rt2500pci_set_device_state: Error - Device failed to enter state 1 (-16).
>>>
>>>  Sometimes the driver just start spamming like crazy sometimes is at less rate
>>>  sometimes it does not appear.
>>>
>>>  I'm running 2.6.31 with a revert [1] config follows. If more info is needed
>>>  just ask
>>>
>>>  [1] http://bugzilla.kernel.org/show_bug.cgi?id=13362
>>
>> Try disabling powersaving,
>>
>>        iwconfig wlan0 power off
>
> I have an identical problem, which is fixed by this command.
>
> It is possible to detect that the chip doesn't, for whatever reason,
> support powersaving and disable it in the driver?

Well I simply have to:
a) fix the driver to handle powersaving better
b) disable powersaving support for the driver

It will probably be (b) first followed by (a) much later if I ever
get the time to look into the issue.

Ivo
