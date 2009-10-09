Return-Path: <linux-kernel-owner+w=401wt.eu-S932583AbZJIC4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbZJIC4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 22:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932308AbZJIC4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 22:56:03 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:65006 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269AbZJIC4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 22:56:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:in-reply-to:message-id:references:user-agent
         :x-archive:mime-version:content-type;
        b=M/9oIUl/+cJ1ZiHDH4WGcvqStH0CCjMeNXjpv8AwE9j0O8hI90Xf6ydTqlT4VQjoun
         QKbtpSMrWPLuQ63gQ/CL4IHXc4nA/K1HFT0MOXUxUIqPcRZZm6HqwyVX4mR0LmTznAwE
         Pn1FNCb+SJFRyuX4ZU+ao5Fmz2MxQCscufyd4=
Date: Thu, 8 Oct 2009 23:55:19 -0300 (BRST)
From: "=?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?=" 
	<fredlwm@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: keyboard under X with 2.6.31
In-Reply-To: <20091009023844.GA26462@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.01.0910082347470.23080@dyndns.pervalidus.net>
References: <alpine.LNX.2.01.0910071706490.11297@dyndns.pervalidus.net> <20091009023844.GA26462@core.coreip.homeip.net>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
X-Archive: encrypt
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1249076227-1255056923=:23080"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1249076227-1255056923=:23080
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 8 Oct 2009, Dmitry Torokhov wrote:

> On Wed, Oct 07, 2009 at 05:19:25PM -0300, Frédéric L. W. Meunier wrote:
>> My keyboard (ABNT2 PS/2) seems to be broken under X with 2.6.31.2. After
>> less than an hour, it starts acting crazy. The first time, all leds
>> turned off and I couldn't type anything. The second time, all leds also
>> turned off, but since it happened while I was pressing the Backspace key
>> to delete text, it continued deleting, like if the key was pressed.
>>
>> In both cases, the mouse (USB) still works and I can exit X, where the
>> keyboard works. There's nothing in the logs.
>>
>> No problem with 2.6.30.9. Is it supposed to be a kernel or X bug ?
>
> It would be interestig to see if the same keyboard continues to work in
> console... if it does then I'd blame X.

I can exit X with the mouse and do anything in the console after 
that.

I just reported it to the XOrg mailing-list.

Anyway, I wonder if DRI could mess with the keyboard. I suppose 
there were changes (and Radeon related) from 2.6.30 to 2.6.31. 
But I can test with it disabled.
--8323328-1249076227-1255056923=:23080--
