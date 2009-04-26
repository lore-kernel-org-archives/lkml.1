Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbZDZRHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbZDZRHG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 13:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZDZRGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 13:06:54 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:44100 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753377AbZDZRGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 13:06:54 -0400
Message-ID: <49F494AC.1040708@pardus.org.tr>
Date: Sun, 26 Apr 2009 20:06:52 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: The current status of info, err and warn macros in kernel
References: <49F39786.6020303@pardus.org.tr> <49F48A0E.30301@phoenixsoftware.de>
In-Reply-To: <49F48A0E.30301@phoenixsoftware.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Ozan Çağlayan schrieb:
>   
>> I noticed that I can't compile some out-of-tree modules like lirc,
>> lmpcm_usb on my 2.6.30_rc* source tree.
>> The compiler aborts saying "implicit declaration of function 'info'". [...] 
>> I don't think that those macros are completely removed because it seems
>> that they're still heavily in use
>> after grepping on current linus-2.6 tree.
>>     
>
> Your grepping must have been inexact. info() and warn() have been removed
> completely in 2.6.29 already, and are indeed used nowhere in the current
> tree. (err() is still there, though probably not for long.)
>
> Suitable replacements are either the dev_* macros from device.h (only
> usable if there is a reliably valid device pointer available - be
> careful when using them in error handling!) or the pr_* macros from
> kernel.h with an appropriate definition of pr_fmt(f).
>   

Thanks for the answer,

Regards,
