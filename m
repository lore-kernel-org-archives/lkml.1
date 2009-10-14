Return-Path: <linux-kernel-owner+w=401wt.eu-S1761219AbZJNCHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761219AbZJNCHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 22:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761121AbZJNCHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 22:07:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:55966 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759333AbZJNCHC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 22:07:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:content-type:content-transfer-encoding:x-mailer
         :mime-version:subject:date:cc;
        b=o8+5woczTdm9MGdRGTnsZ/lO5YaCPhAzjMvBhQqc7kAhF2eweakQ0Wsk3x+rQ6qjtA
         TDI4rDtVSKJfqcLgWAzWM1z+TOcEMcXLp2DjqkIfczR555+EOzIohhVq6zPVNy4qQ60Z
         G3I+z2bP7SeAhESToOdLq7i02XyhcZm17oplQ=
Message-Id: <928C125D-D36B-47C9-A549-3EE502C9EC73@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?utf-8?Q?=C3=89ric_Piel?= <eric.piel@tremplin-utc.net>
Content-Type: text/plain;
	charset=utf-8;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 8BIT
X-Mailer: iPhone Mail (7C144)
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work anymore
Date: Tue, 13 Oct 2009 19:05:05 -0700
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 11:52:19AM +0200, Éric Piel wrote:
> Op 12-10-09 17:48, Dmitry Torokhov schreef:
>> On Mon, Oct 12, 2009 at 01:46:17PM +0200, Éric Piel wrote:
>>>> Eric, do you still need to fiddle with i8042 to get your keyboard  
>>>> working with
>>>> 2.6.32-rc3? We need to make sure that resube works without users  
>>>> needing to
>>>> mess with bind/unbind.
>>> Yes, the keyboard doesn't work after the first resume from ram (the
>>> later resumes do work). I haven't tried any special option to the  
>>> i8042
>>> driver. This is on a HP 2510, in 64 bits.
>>
>> Could you please try and let me know if unloading at suspend and
>> reloading after resume atkbd and/or psmouse drivers and leaving i8042
>> alone "fixes" the issue?
>>
> Unloading the modules before suspend and reloading them after works
> around the issue, indeed.
>

Do both of them need to be reloaded? Or only one (my guess psmouse) is
enough. Hmm, this is HP laptop so it most likely has Synaptics touchpad.
I wonder what happens if you force it to bare PS/2 protocol (or maybe
Intellimouse)... Try adding "option psmouse proto=imps" and
"option psmouse proto=bare" and suspend/resume.

-- 
Dmitry
