Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbYJZHZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbYJZHZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 03:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYJZHZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 03:25:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:17395 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYJZHZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 03:25:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vb62TpqHA6ZwJHpKmKbZin43H2XATML/PNNfPJoEhIraRZk3pHsy2bmtN4389zMS5p
         uKzOB6knjVH/AcoOopNxg6u6fI14FOGPUGVvN/XD1zgKq4FM8Bd7XtXsaWmfRifsJ0wi
         /zVknDclKYA6H3hgcyykqO5nmilqdkXrXRmO0=
Message-ID: <49041B73.8060603@gmail.com>
Date: Sun, 26 Oct 2008 08:25:39 +0100
From: "Mikko C." <mikko.cal@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080927)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Random problems with 2.6.28-rc1-git1
References: <490332E5.3020108@gmail.com> <Pine.LNX.4.64.0810260235490.22126@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0810260235490.22126@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina ha scritto:
> On Sat, 25 Oct 2008, Mikko C. wrote:
>   
>> Today I tried upgrading to 2.6.28-rc1-git1 (-rc1 couldn't even mount the 
>> disk). I'm having some problems with it :)
>> 1) Whenever I try to unload (rmmod or modprobe -r) *any* modules (even 
>>    if not used), the system hangs.  I can still move the mouse and see 
>>    the cursor moving, but I can't type, can't switch console, nothing.  
>>    Because of this, I can't shutdown the system properly because it 
>>    hangs when "Unloading ALSA modules"
>>     
>
> If rmmod never returns, alt-sysrq-t output should show us where it got 
> stuck.
>
>   
Thanks for your answer
I tried Alt-Sysrq-T after a rmmod, but all I get is:
"SysRq : Show State"

Is it normal? Does it dump the information to a log?
Sorry but I never used sysrq in the past.

>> 2) Sometimes (randomly it seems) the system doesn't detect any usb 
>>    devices:  I have an external HD and a Logitech mouse. Sometimes they 
>>    are recognized, sometimes not.  Unplugging and re-plugging them 
>>    doesn't help. lsusb shows no attached device.
>>     
>
> Compiling with CONFIG_USB_DEBUG and sending report to 
> linux-usb@vger.kernel.org with the output included might be a good start.
>   
Ok, done: http://marc.info/?l=linux-usb&m=122500580917403&w=2

Thanks
