Return-Path: <linux-kernel-owner+w=401wt.eu-S1760229AbZJIDUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229AbZJIDUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 23:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760209AbZJIDUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 23:20:17 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:44758 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbZJIDUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 23:20:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lNwuiU82fAlbyP97qS9YLf5AwWnKZACuqTclpI3ZHzW6r9LsvGAKGzxK6Z43Smcs80
         AX8pjl7dY+UuTlj0Okr2H2gVAYVvFRTFtJZx3MCVrs1od5sMv7nx9CX/Sg1TiHJ7T3LJ
         /Anx0K6BCBPHmU3vKYGLKtmHpSY7xKpFKMvNQ=
Message-ID: <4ACEABAA.3070707@gmail.com>
Date: Thu, 08 Oct 2009 20:19:06 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=22Fr=E9d=E9ric_L=2E_W=2E_Meunier=22?= 
	<fredlwm@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: keyboard under X with 2.6.31
References: <alpine.LNX.2.01.0910071706490.11297@dyndns.pervalidus.net> <20091009023844.GA26462@core.coreip.homeip.net> <alpine.LNX.2.01.0910082347470.23080@dyndns.pervalidus.net>
In-Reply-To: <alpine.LNX.2.01.0910082347470.23080@dyndns.pervalidus.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric L. W. Meunier wrote:
> On Thu, 8 Oct 2009, Dmitry Torokhov wrote:
>
>> On Wed, Oct 07, 2009 at 05:19:25PM -0300, Frédéric L. W. Meunier wrote:
>>> My keyboard (ABNT2 PS/2) seems to be broken under X with 2.6.31.2. 
>>> After
>>> less than an hour, it starts acting crazy. The first time, all leds
>>> turned off and I couldn't type anything. The second time, all leds also
>>> turned off, but since it happened while I was pressing the Backspace 
>>> key
>>> to delete text, it continued deleting, like if the key was pressed.
>>>
>>> In both cases, the mouse (USB) still works and I can exit X, where the
>>> keyboard works. There's nothing in the logs.
>>>
>>> No problem with 2.6.30.9. Is it supposed to be a kernel or X bug ?
>>
>> It would be interestig to see if the same keyboard continues to work in
>> console... if it does then I'd blame X.
>
> I can exit X with the mouse and do anything in the console after that.
>
> I just reported it to the XOrg mailing-list.
>
> Anyway, I wonder if DRI could mess with the keyboard. I suppose there 
> were changes (and Radeon related) from 2.6.30 to 2.6.31. But I can 
> test with it disabled.
mess around(maybe) with .xmodmap,
if before X mess with /usr/share/keymap/ *.gz(whatever your using)

Justin P. Mattock
