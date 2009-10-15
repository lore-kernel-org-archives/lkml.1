Return-Path: <linux-kernel-owner+w=401wt.eu-S935359AbZJOTwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935359AbZJOTwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759355AbZJOTwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:52:30 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:61357 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635AbZJOTw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:52:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=md39B13lam+BvKWFyhmRghcJ1p7ux2JQHUgciocxPamVLB5U+VLO9fehKeod4aJ9ly
         DtdqUkCR8kO25S7aiUmtCeKxOQ2yKRd5cTd2+io1oqNMqhmFrNfQQGLaR63AbVcwhT2d
         WRkGM3e+rbjYYZUbMxwUeR+nWRsBumfaFl/6M=
Date: Thu, 15 Oct 2009 12:51:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-1?Q?=C9ric?= Piel <Eric.Piel@tremplin-utc.net>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work
	anymore
Message-ID: <20091015195136.GD8544@core.coreip.homeip.net>
References: <928C125D-D36B-47C9-A549-3EE502C9EC73@gmail.com> <4AD75AC0.6020705@tremplin-utc.net> <20091015181336.GB8544@core.coreip.homeip.net> <4AD778C7.4070707@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AD778C7.4070707@tremplin-utc.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 09:32:23PM +0200, Éric Piel wrote:
> Op 15-10-09 20:13, Dmitry Torokhov schreef:
>> It lokks like the keyboard controller switched from translated to
>> non-translated mode: '1c' is make code and 'f0 1c' is break (aka
>> release) code.
>>
>> Could you tell me how the keyboard indentified (in dmesg) after fresh
>> boot and after you do the bind/unbind trick on the older kernel?
>>
> What do you mean by "how the keyboard indentified"? Are you asking for  
> the debug trace in dmesg? I have the beginning of a boot with the debug  
> trace to see after a fresh boot. I don't have dmesg history with  
> i8042.debug of the bind/unbind trick, so I'll reboot in an old kernel  
> and do it again (but I cannot do this before tuesday, when i have  
> physical access to the machine).

No, not the debug.. Just the lines looking like this:

input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3


You should have at leat 2 - one uping initial boot and one after
rebinding i8042 upon resume.

-- 
Dmitry
