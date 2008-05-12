Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbYELFu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbYELFu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 01:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYELFut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 01:50:49 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:2525 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYELFus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 01:50:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hzDTB/W8CvJCJnrkx4U69y3YPBgTzKIuMkA6+686zJS6O6AwqpJPnv52ZLY8i4tiGQ1IZPfCX9NmlwCmM5pzcMzDyp9omN2LWS7/utrMzwT+O4DoLCRt2TbHSIHWtNzwsXybeGtYmQE/HyEnyJFhMNYj+wzIL6Da0l9ld5zoelo=
Message-ID: <386072610805112250p33e1c10cm347682fc5fe40d55@mail.gmail.com>
Date: Mon, 12 May 2008 13:50:42 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Javier Herrero" <jherrero@hvsistemas.es>
Subject: Re: [PATCH 1/1 try#2] [INPUT] keypad driver: Added support for OpenCores Keyboard Controller
Cc: "Vojtech Pavlik" <vojtech@suse.cz>, "Bryan Wu" <bryan.wu@analog.com>,
       "Will Newton" <will.newton@gmail.com>, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <47A84979.5080004@hvsistemas.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1201686610-31458-1-git-send-email-bryan.wu@analog.com>
	 <87a5b0800801300353l196b39bekad6af6ccdbd49d5b@mail.gmail.com>
	 <1201713502.8345.1.camel@roc-laptop> <20080205104242.GA11437@suse.cz>
	 <47A845F7.8030102@hvsistemas.es> <20080205112242.GA5398@suse.cz>
	 <47A84979.5080004@hvsistemas.es>
X-Google-Sender-Auth: a6d1aa6532f265f1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2008 at 7:33 PM, Javier Herrero <jherrero@hvsistemas.es> wrote:
> Vojtech Pavlik escribió:
>>
>> On Tue, Feb 05, 2008 at 12:18:15PM +0100, Javier Herrero wrote:
>>>
>>> Dear Vojtech,
>>>
>>> I think that a 1:1 mapping between linux keycodes and what keyboard sends
>>> is right, because the scan code to key code conversion is already programmed
>>> and done inside the FPGA code.
>>
>> And the FPGA code changes with different keyboards attached?
>>
> The original OpenCores keyboard controller is a 6 rows x 12 cols keyboard
> controller that can be customized for other row/col sizes modifiying
> Constants.vhd VHDL file, in which also the translation table is defined, and
> for different key disposition schemes both the number of rows and cols can
> be changed. We are currently using this controller with a 4x4 key matrix,
> and with a different key mapping values, so I thought that it would be
> preferable to have the driver mapping fixed to 1:1 and do the mapping in the
> VHDL, since in most cases the keyboard using this controller would be
> different to the default keyboard defined in the original Contants.vhd VHDL
> file.
>
> Regards,
>
> Javier
>

Hi Vojtech, Will and Dmitry,

How do you think of this driver from Javier?
It works fine on Blackfin arch, but it can also be shared by other platform.
So this driver is useful of the other developers.
Could you please consider merging this driver?

If you need me to resend this patch, please ping me.

Thanks
-Bryan
